package restscenario

import (
	"net/http"
	"testing"
)

func TestRestApi(t *testing.T) {
	t.Run("rest api full test for mock driver", func(t *testing.T) {
		setUpForRest()

		tc := TestCases{
			name:             "create cluster",
			echoFunc:         "CreateCluster",
			httpMethod:       http.MethodPost,
			whenURL:          "/ladybug/ns/:namespace/clusters",
			givenQueryParams: "",
			givenParaNames:   []string{"namespace"},
			givenParaVals:    []string{"ns-unit-01"},
			givenPostData: `{
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
											}`,
			expectStatus:         http.StatusOK,
			expectBodyStartsWith: `{"name":"cb-cluster","kind":"Cluster"`,
		}
		EchoTest(t, tc)

		tearDownForRest()
	})

}
