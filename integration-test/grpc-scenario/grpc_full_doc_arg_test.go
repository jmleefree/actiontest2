package grpcscenario

import (
	"testing"
)

func TestGrpcFullDocArg(t *testing.T) {
	t.Run("grpc api full test for mock driver by doccument args style", func(t *testing.T) {
		setUpForGrpc()

		tc := TestCases{
			name:     "create cluster",
			instance: mcarApi,
			method:   "CreateCluster",
			args: []interface{}{
				`{
					"namespace":  "ns-unit-01",
					"ReqInfo": {
							"name": "cb-cluster",
							"controlPlane" : [{
								"connection": "mock-unit-config01",
								"count": 1,
								"spec": "mock-vmspec-01"
							}],
							"worker": [{
								"connection": "mock-unit-config01",
								"count": 1,
								"spec": "mock-vmspec-01"
							}],
							"config": {
								"kubernetes": {
									"networkCni": "kilo",
									"podCidr": "10.244.0.0/16",
									"serviceCidr": "10.96.0.0/12",
									"serviceDnsDomain": "cluster.local"
								}
							}
						}
				}`,
			},
			expectResStartsWith: `{"name":"cb-cluster","kind":"Cluster"`,
		}
		MethodTest(t, tc)

		tearDownForGrpc()
	})

}
