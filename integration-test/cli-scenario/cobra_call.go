package cliscenario

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
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

	t.Run(tc.name, func(t *testing.T) {

		ladybugCmd := cmd.NewRootCmd()
		b := bytes.NewBufferString("")
		ladybugCmd.SetOut(b)
		ladybugCmd.SetArgs(tc.cmdArgs)
		ladybugCmd.Execute()

		out, err := ioutil.ReadAll(b)

		if assert.NoError(t, err) {
			dst := new(bytes.Buffer)
			fmt.Printf("===== out : %s\n", string(out))
			err = json.Compact(dst, out)
			if assert.NoError(t, err) {
				res = dst.String()
				fmt.Printf("===== result : %s\n", res)
				if tc.expectResStartsWith != "" {
					assert.True(t, strings.HasPrefix(res, tc.expectResStartsWith))
				} else {
					assert.Equal(t, "", res)
				}
			}
		}

	})

	return res, err
}
