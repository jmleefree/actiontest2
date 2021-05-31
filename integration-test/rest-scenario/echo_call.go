package restscenario

import (
	"bytes"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"reflect"
	"strings"
	"testing"

	"github.com/jmleefree/actiontest2/src/rest-api/router"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

var funcs = map[string]interface{}{
	"ListCluster":   router.ListCluster,
	"CreateCluster": router.CreateCluster,
	"GetCluster":    router.GetCluster,
	"DeleteCluster": router.DeleteCluster,
	"ListNode":      router.ListNode,
	"AddNode":       router.AddNode,
	"GetNode":       router.GetNode,
	"RemoveNode":    router.RemoveNode,
}

func Call(m map[string]interface{}, name string, params ...interface{}) (result []reflect.Value, err error) {
	f := reflect.ValueOf(m[name])
	if len(params) != f.Type().NumIn() {
		err = errors.New("The number of params is not adapted.")
		return
	}

	in := make([]reflect.Value, len(params))
	for k, param := range params {
		in[k] = reflect.ValueOf(param)
	}
	result = f.Call(in)
	return
}

func EchoGetTest(t *testing.T, tc TestCases) (string, error) {

	var (
		body string = ""
		err  error  = nil
	)

	t.Run(tc.name, func(t *testing.T) {
		e := echo.New()
		var req *http.Request = nil
		if tc.givenPostData != "" {
			req = httptest.NewRequest(http.MethodGet, "/"+tc.givenQueryParams, bytes.NewBuffer([]byte(tc.givenPostData)))
		} else {
			req = httptest.NewRequest(http.MethodGet, "/"+tc.givenQueryParams, nil)
		}
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)
		c.SetPath(tc.whenURL)
		if tc.givenParaNames != nil {
			c.SetParamNames(tc.givenParaNames...)
			c.SetParamValues(tc.givenParaVals...)
		}

		_, err = Call(funcs, tc.echoFunc, c)
		if assert.NoError(t, err) {
			assert.Equal(t, tc.expectStatus, rec.Code)
			body = rec.Body.String()
			fmt.Printf("===== body : %s\n", body)
			if tc.expectBodyStartsWith != "" {
				assert.True(t, strings.HasPrefix(body, tc.expectBodyStartsWith))
			} else {
				assert.Equal(t, "", body)
			}
		}
	})

	return body, err
}

func EchoPostTest(t *testing.T, tc TestCases) (string, error) {

	var (
		body string = ""
		err  error  = nil
	)

	t.Run(tc.name, func(t *testing.T) {
		e := echo.New()
		var req *http.Request = nil
		if tc.givenPostData != "" {
			req = httptest.NewRequest(http.MethodPost, "/"+tc.givenQueryParams, bytes.NewBuffer([]byte(tc.givenPostData)))
		} else {
			req = httptest.NewRequest(http.MethodPost, "/"+tc.givenQueryParams, nil)
		}
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)
		c.SetPath(tc.whenURL)
		if tc.givenParaNames != nil {
			c.SetParamNames(tc.givenParaNames...)
			c.SetParamValues(tc.givenParaVals...)
		}

		_, err = Call(funcs, tc.echoFunc, c)
		if assert.NoError(t, err) {
			assert.Equal(t, tc.expectStatus, rec.Code)
			body = rec.Body.String()
			fmt.Printf("===== body : %s\n", body)
			if tc.expectBodyStartsWith != "" {
				assert.True(t, strings.HasPrefix(body, tc.expectBodyStartsWith))
			} else {
				assert.Equal(t, "", body)
			}
		}
	})

	return body, err
}

func EchoDeleteTest(t *testing.T, tc TestCases) (string, error) {

	var (
		body string = ""
		err  error  = nil
	)

	t.Run(tc.name, func(t *testing.T) {
		e := echo.New()
		var req *http.Request = nil
		if tc.givenPostData != "" {
			req = httptest.NewRequest(http.MethodDelete, "/"+tc.givenQueryParams, bytes.NewBuffer([]byte(tc.givenPostData)))
		} else {
			req = httptest.NewRequest(http.MethodDelete, "/"+tc.givenQueryParams, nil)
		}
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)
		c.SetPath(tc.whenURL)
		if tc.givenParaNames != nil {
			c.SetParamNames(tc.givenParaNames...)
			c.SetParamValues(tc.givenParaVals...)
		}

		_, err = Call(funcs, tc.echoFunc, c)
		if assert.NoError(t, err) {
			assert.Equal(t, tc.expectStatus, rec.Code)
			body = rec.Body.String()
			fmt.Printf("===== body : %s\n", body)
			if tc.expectBodyStartsWith != "" {
				assert.True(t, strings.HasPrefix(body, tc.expectBodyStartsWith))
			} else {
				assert.Equal(t, "", body)
			}
		}
	})

	return body, err
}
