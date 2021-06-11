package restscenario

import (
	"bytes"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
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

func EchoTest(t *testing.T, tc TestCases) (string, error) {

	var (
		body string = ""
		err  error  = nil
	)

	t.Run(tc.Name, func(t *testing.T) {
		e := echo.New()
		var req *http.Request = nil
		if tc.GivenPostData != "" {
			req = httptest.NewRequest(tc.HttpMethod, "/"+tc.GivenQueryParams, bytes.NewBuffer([]byte(tc.GivenPostData)))
		} else {
			req = httptest.NewRequest(tc.HttpMethod, "/"+tc.GivenQueryParams, nil)
		}
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)
		c.SetPath(tc.WhenURL)
		if tc.GivenParaNames != nil {
			c.SetParamNames(tc.GivenParaNames...)
			c.SetParamValues(tc.GivenParaVals...)
		}

		_, err = Call(funcs, tc.EchoFunc, c)
		if assert.NoError(t, err) {
			assert.Equal(t, tc.ExpectStatus, rec.Code)
			body = rec.Body.String()
			if tc.ExpectBodyStartsWith != "" {
				if !assert.True(t, strings.HasPrefix(body, tc.ExpectBodyStartsWith)) {
					fmt.Fprintf(os.Stderr, "\n                Not Equal: \n"+
						"                  Expected Start With: %s\n"+
						"                  Actual  : %s", tc.ExpectBodyStartsWith, body)
				}
			} else {
				if !assert.Equal(t, "", body) {
					fmt.Fprintf(os.Stderr, "\n                Not Equal: \n"+
						"      Expected Start With: %s\n"+
						"      Actual  : %s", tc.ExpectBodyStartsWith, body)
				}
			}
		}
	})

	return body, err
}
