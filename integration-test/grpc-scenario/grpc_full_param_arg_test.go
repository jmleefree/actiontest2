package grpcscenario

import (
	"testing"
)

func TestGrpcFullParamArg(t *testing.T) {
	t.Run("grpc api full test for mock driver by parameter args style", func(t *testing.T) {
		SetUpForGrpc()

		TearDownForGrpc()
	})

}
