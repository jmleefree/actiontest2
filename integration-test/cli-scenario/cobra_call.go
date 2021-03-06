package cliscenario

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"testing"

	"github.com/jmleefree/actiontest2/src/grpc-api/cbadm/cmd"
	"github.com/stretchr/testify/assert"
)

func LadybugCmdTest(t *testing.T, tc TestCases) (string, error) {

	var (
		res string = ""
		err error  = nil
	)

	t.Run(tc.Name, func(t *testing.T) {

		ladybugCmd := cmd.NewRootCmd()
		b := bytes.NewBufferString("")
		ladybugCmd.SetOut(b)
		ladybugCmd.SetArgs(tc.CmdArgs)
		ladybugCmd.Execute()

		out, err := ioutil.ReadAll(b)

		if assert.NoError(t, err) {
			if strings.HasPrefix(string(out), "{") {
				dst := new(bytes.Buffer)
				err = json.Compact(dst, out)
				if assert.NoError(t, err) {
					res = dst.String()
				}
			} else {
				res = string(out)
			}

			if tc.ExpectResStartsWith != "" {
				if !assert.True(t, strings.HasPrefix(res, tc.ExpectResStartsWith)) {
					fmt.Fprintf(os.Stderr, "\n                Not Equal: \n"+
						"                  Expected Start With: %s\n"+
						"                  Actual  : %s", tc.ExpectResStartsWith, res)
				}
			} else {
				if !assert.Equal(t, "", res) {
					fmt.Fprintf(os.Stderr, "\n                Not Equal: \n"+
						"      Expected Start With: %s\n"+
						"      Actual  : %s", tc.ExpectResStartsWith, res)
				}
			}
		}

	})

	return res, err
}
