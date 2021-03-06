#!/bin/bash
# ------------------------------------------------------------------------------
# usage
if [ "$1" == "-h" ]; then 
	echo "./init.sh [AWS/GCP]"
	echo "./init.sh GCP"
	exit 0
fi

# ------------------------------------------------------------------------------
# const

c_URL_SPIDER="http://localhost:1024/spider"
c_URL_TUMBLEBUG="http://localhost:1323/tumblebug"
c_CT="Content-Type: application/json"
c_AUTH="Authorization: Basic $(echo -n default:default | base64)"
c_AWS_DRIVER="aws-driver-v1.0"
c_GCP_DRIVER="gcp-driver-v1.0"

# ------------------------------------------------------------------------------
# env.

# ${PREFIX} : name prefix
# ${CSP} : 클라우드 (AWS/GCP)
# ${REGIN} : region
# ${ZONE} : zone

# GCP env.
# ${PROJECT} : GCP 프로젝트이름
# ${SA} : GCP service account
# ${PKEY} : GCP private key

# AWS env.
# ${KEY} : AWS (aws_access_key_id)
# ${SECRET} : AWS (aws_secret_access_key)

echo "[ENV.]"
echo "- CSP     : ${CSP}"
echo "- PREFIX  : ${PREFIX}"
echo "- REGIN   : ${REGIN}"
echo "- ZONE    : ${ZONE}"
echo "- PROJECT : ${PROJECT}"
echo "- SA      : ${SA}"
echo "- PKEY    : ${PKEY}"
echo "- KEY     : ${KEY}"
echo "- SECRET  : ${SECRET}"



# ------------------------------------------------------------------------------
# variables

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
# # 2. PREFIX
# if [ "$#" -gt 1 ]; then v_PREFIX="$2"; else	v_PREFIX="${PREFIX}"; fi
# if [ "${v_PREFIX}" == "" ]; then 
# 	read -e -p "Name prefix ? : "  v_PREFIX
# fi
# if [ "${v_PREFIX}" == "" ]; then v_PREFIX="${v_CSP}"; fi

NM_REGION="${v_PREFIX}-region"
NM_CREDENTIAL="${v_PREFIX}-credential"
NM_CONFIG="${v_PREFIX}-config"
NM_NAMESPACE="${v_PREFIX}-namespace"


# GCP
if [ "${v_CSP}" == "GCP" ]; then 

	# driver
	v_DRIVER="${c_GCP_DRIVER}"

	# Project
	v_GCP_PROJECT="${PROJECT}"
	if [ "${v_GCP_PROJECT}" == "" ]; then 
		read -e -p "Project ? [예:kore3-etri-cloudbarista] : "  v_GCP_PROJECT
		if [ "${v_GCP_PROJECT}" == "" ]; then echo "[ERROR] missing gcp <project_id>"; exit -1;fi
	fi

	# private key
	v_GCP_PKEY="${PKEY}"
	if [ "${v_GCP_PKEY}" == "" ]; then 
		read -e -p "Private Key ? [예:-----BEGIN PRIVATE KEY-----\n....] : "  v_GCP_PKEY
		if [ "${v_GCP_PKEY}" == "" ]; then echo "[ERROR] missing gcp <private_key>"; exit -1;fi
	fi

	# system account
	v_GCP_SA="${SA}"
	if [ "${v_GCP_SA}" == "" ]; then 
		read -e -p "Service account (client email) ? [예:331829771895-compute@developer.gserviceaccount.com] : "  v_GCP_SA
		if [ "${v_GCP_SA}" == "" ]; then echo "[ERROR] missing gcp <client_email>"; exit -1;fi
	fi

fi

# AWS
if [ "${v_CSP}" == "AWS" ]; then 
	# driver
	v_DRIVER="${c_AWS_DRIVER}"

	v_AWS_ACCESS_KEY="${KEY}"
	if [ "${v_AWS_ACCESS_KEY}" == "" ]; then 
		read -e -p "Access Key ? [예:AH24UUA2ZGNOP6DKKIA6] : "  v_AWS_ACCESS_KEY
		if [ "${v_AWS_ACCESS_KEY}" == "" ]; then echo "[ERROR] missing <aws_access_key_id>"; exit -1;fi
	fi

	v_AWS_SECRET="${SECRET}"
	if [ "${v_AWS_SECRET}" == "" ]; then 
		read -e -p "Access-key Secret ? [예:y76ZWz6A/vwqGanDAI926TTPCJrrMo1VbPOh8X7K] : "  v_AWS_SECRET
		if [ "${v_AWS_SECRET}" == "" ]; then echo "[ERROR] missing <aws_secret_access_key>"; exit -1;fi
	fi

fi

# region
v_REGION="${REGION}"
if [ "${v_REGION}" == "" ]; then 
	read -e -p "region ? [예:asia-northeast3] : "  v_REGION
	if [ "${v_REGION}" == "" ]; then echo "[ERROR] missing region"; exit -1;fi
fi

# zone
v_ZONE="${ZONE}"
if [ "${v_ZONE}" == "" ]; then 
	read -e -p "zone ? [예:asia-northeast3-a] : "  v_ZONE
	if [ "${v_ZONE}" == "" ]; then v_ZONE="${v_REGION}-a";fi
fi

# ------------------------------------------------------------------------------
# print info.
echo ""
echo "[INFO]"
echo "- PREFIX                     is '${v_PREFIX}'"
echo "- Cloud                      is '${v_CSP}'"
echo "- Driver                     is '${v_DRIVER}'"
echo "- Region                     is '${v_REGION}'"
echo "- Zone                       is '${v_ZONE}'"

if [ "${v_CSP}" == "GCP" ]; then 
	echo "- Project                    is '${v_GCP_PROJECT}'"
	echo "- private key                is '${v_GCP_PKEY}'"
	echo "- Service account            is '${v_GCP_SA}'"
fi
if [ "${v_CSP}" == "AWS" ]; then 
 	echo "- aws_access_key_id          is '${v_AWS_ACCESS_KEY}'"
	echo "- aws_secret_access_key      is '${v_AWS_SECRET}'"
fi

echo "- (Name of region)           is '${NM_REGION}'"
echo "- (Name of credential)       is '${NM_CREDENTIAL}'"
echo "- (Name of Connection Info.) is '${NM_CONFIG}'"
echo "- (Name of namespace)        is '${NM_NAMESPACE}'"


# ------------------------------------------------------------------------------
# Configuration Spider / Thumblebug
init() {

	# driver
	$APP_ROOT/src/grpc-api/cbadm/cbadm driver delete --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${v_DRIVER}
	$APP_ROOT/src/grpc-api/cbadm/cbadm driver create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
			'{
					"DriverName"        : "'${v_DRIVER}'",
					"ProviderName"      : "'${v_CSP}'",
					"DriverLibFileName" : "'${v_DRIVER}'.so"
			}'	

	# region
	$APP_ROOT/src/grpc-api/cbadm/cbadm region delete --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_REGION}
	$APP_ROOT/src/grpc-api/cbadm/cbadm region create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml  -i json -o json -d \
			'{
					"RegionName"       : "'${NM_REGION}'",
					"ProviderName"     : "'${v_CSP}'", 
					"KeyValueInfoList" : [
						{"Key" : "Region", "Value" : "'${v_REGION}'"},
						{"Key" : "Zone",   "Value" : "'${v_ZONE}'"}
					]
			}'

	# credential
	if [ "${v_CSP}" == "GCP" ]; then
		$APP_ROOT/src/grpc-api/cbadm/cbadm credential delete --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_CREDENTIAL}
    $APP_ROOT/src/grpc-api/cbadm/cbadm credential create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
			'{
					"CredentialName"   : "'${NM_CREDENTIAL}'",
					"ProviderName"     : "'${v_CSP}'",
					"KeyValueInfoList" : [
						{"Key" : "ClientEmail", "Value" : "'${v_GCP_SA}'"},
						{"Key" : "ProjectID",   "Value" : "'${v_GCP_PROJECT}'"},
						{"Key" : "PrivateKey",  "Value" : "'${v_GCP_PKEY}'"}
					]
			}'
	fi

	if [ "${v_CSP}" == "AWS" ]; then
		$APP_ROOT/src/grpc-api/cbadm/cbadm credential delete --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_CREDENTIAL}
    $APP_ROOT/src/grpc-api/cbadm/cbadm credential create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
			'{
					"CredentialName"   : "'${NM_CREDENTIAL}'",
					"ProviderName"     : "'${v_CSP}'",
					"KeyValueInfoList" : [
						{"Key" : "ClientId",       "Value" : "'${v_AWS_ACCESS_KEY}'"},
						{"Key" : "ClientSecret",   "Value" : "'${v_AWS_SECRET}'"}
					]
			}'		
	fi

	# config
	$APP_ROOT/src/grpc-api/cbadm/cbadm connect-info delete --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_CONFIG}
	$APP_ROOT/src/grpc-api/cbadm/cbadm connect-info create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
			'{
					"ConfigName"     : "'${NM_CONFIG}'",
					"ProviderName"   : "'${v_CSP}'", 
					"DriverName"     : "'${v_DRIVER}'", 
					"CredentialName" : "'${NM_CREDENTIAL}'", 
					"RegionName"     : "'${NM_REGION}'"
			}'

	# namespace
	$APP_ROOT/src/grpc-api/cbadm/cbadm namespace create --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -i json -o json -d \
		'{
				"name"        : "'${NM_NAMESPACE}'",
				"description" : ""
		}' 	

}


# ------------------------------------------------------------------------------
# show init result
show() {
	echo "DRIVER";     $APP_ROOT/src/grpc-api/cbadm/cbadm driver get --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${v_DRIVER} 
	echo "REGION";     $APP_ROOT/src/grpc-api/cbadm/cbadm region get --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_REGION} 
	echo "CREDENTIAL"; $APP_ROOT/src/grpc-api/cbadm/cbadm credential get --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_CREDENTIAL} 
	echo "CONFIG";     $APP_ROOT/src/grpc-api/cbadm/cbadm connect-info get --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json -n ${NM_CONFIG}
	echo "NAMESPACE";  $APP_ROOT/src/grpc-api/cbadm/cbadm namespace get --config $APP_ROOT/src/grpc-api/cbadm/grpc_conf.yaml -o json --ns ${NM_NAMESPACE}
}

# ------------------------------------------------------------------------------
if [ "$1" != "-h" ]; then 
	echo ""
	echo "------------------------------------------------------------------------------"
	init;	show;
fi
