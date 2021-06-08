package cliscenario

import (
	"testing"
)

func TestCliFull(t *testing.T) {
	t.Run("command full test for mock driver", func(t *testing.T) {
		setUpForCli()

		tc := TestCases{
			name: "create cluster",
			cmdArgs: []string{"cluster", "create", "--config", "../conf/grpc_conf.yaml", "-i", "json", "-o", "json", "-d",
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
		LadybugCmdTest(t, tc)

		tearDownForCli()
	})
}
