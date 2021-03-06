#!/bin/bash
# -----------------------------------------------------------------
# usage
if [ "$#" -lt 1 ]; then 
	echo "node-add.sh [GCP/AWS] <clsuter name> <spec> <worker node count>"
	echo "    ./node-add.sh GCP cb-cluster n1-standard-2 2"
	echo "    ./node-add.sh AWS cb-cluster t2.medium 2"
	exit 0; 
fi


# ------------------------------------------------------------------------------
# const
c_URL_LADYBUG="http://localhost:8080/ladybug"
c_CT="Content-Type: application/json"


# -----------------------------------------------------------------
# parameter


# 1. CSP
if [ "$#" -gt 0 ]; then v_CSP="$1"; else	v_CSP="${CSP}"; fi
if [ "${v_CSP}" == "" ]; then 
	read -e -p "Cloud ? [AWS(default) or GCP] : "  v_CSP
fi
if [ "${v_CSP}" == "" ]; then v_CSP="AWS"; fi
if [ "${v_CSP}" != "GCP" ] && [ "${v_CSP}" != "AWS" ]; then echo "[ERROR] missing <cloud>"; exit -1;fi

# PREFIX
if [ "${v_CSP}" == "GCP" ]; then 
	v_PREFIX="cb-gcp"
else
	v_PREFIX="cb-aws"
fi

# 2. Cluster Name
if [ "$#" -gt 1 ]; then v_CLUSTER_NAME="$2"; else	v_METHOD="${CLUSTER_NAME}"; fi
if [ "${v_CLUSTER_NAME}" == "" ]; then 
	read -e -p "Cluster name  ? : "  v_CLUSTER_NAME
fi
if [ "${v_CLUSTER_NAME}" == "" ]; then echo "[ERROR] missing <cluster name>"; exit -1; fi

# 3. SPEC
if [ "$#" -gt 2 ]; then v_SPEC="$3"; else	v_SPEC="${SPEC}"; fi
if [ "${v_SPEC}" == "" ]; then 
	read -e -p "spec ? [예:n1-standard-2, t2.medium] : "  v_SPEC
fi
if [ "${v_CSP}" == "" ]; then 
	if [ "${v_CSP}" == "GCP" ]; then 
		v_SPEC="n1-standard-2"
	else
		v_SPEC="t2.medium"
	fi
fi

# 4. WORKER_NODE_COUNT
if [ "$#" -gt 3 ]; then v_WORKER_NODE_COUNT="$4"; else	v_WORKER_NODE_COUNT="${WORKER_NODE_COUNT}"; fi
if [ "${v_WORKER_NODE_COUNT}" == "" ]; then 
	read -e -p "worker node count [예:2] : "  v_WORKER_NODE_COUNT
fi
if [ "${v_WORKER_NODE_COUNT}" == "" ]; then v_WORKER_NODE_COUNT="2"; fi


NM_NAMESPACE="${v_PREFIX}-namespace"
NM_CONFIG="${v_PREFIX}-config"
c_URL_LADYBUG_NS="${c_URL_LADYBUG}/ns/${NM_NAMESPACE}"


# ------------------------------------------------------------------------------
# print info.
echo ""
echo "[INFO]"
echo "- Prefix                     is '${v_PREFIX}'"
echo "- Cuseter name               is '${v_CLUSTER_NAME}'"
echo "- Spec                       is '${v_SPEC}'"
echo "- Worker node count          is '${v_WORKER_NODE_COUNT}'"
echo "- Namespace                  is '${NM_NAMESPACE}'"
echo "- (Name of Connection Info.) is '${NM_CONFIG}'"


# ------------------------------------------------------------------------------
# Add Node
create() {

	$APP_ROOT/src/grpc-api/cbadm/cbadm node add --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
	'{
		"namespace":  "'${NM_NAMESPACE}'",
		"cluster":  "'${v_CLUSTER_NAME}'",
		"ReqInfo": {
				"worker": [{
					"connection":  "'${NM_CONFIG}'",
					"count": '${v_WORKER_NODE_COUNT}',
					"spec": "'${v_SPEC}'"
				}]		
		}
	}'

}


# ------------------------------------------------------------------------------
if [ "$1" != "-h" ]; then 
	echo ""
	echo "------------------------------------------------------------------------------"
	create;
fi
