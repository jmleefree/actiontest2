#!/bin/bash

source ./test.env
# must exclude integration-test folder
go test -p 1 -v -coverpkg=$(go list ../... | grep -v integration-test | grep -v protobuf | tr "\n" ",")  -coverprofile=profile.cov ./...
#go tool cover -func=profile.cov