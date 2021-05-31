package mcar

import (
	"time"

	pb "github.com/jmleefree/actiontest2/src/grpc-api/protobuf/cbladybug"
)

// ===== [ Constants and Variables ] =====

// ===== [ Types ] =====

// MCARRequest - MCAR 서비스 요청 구현
type MCARRequest struct {
	Client  pb.MCARClient
	Timeout time.Duration

	InType  string
	InData  string
	OutType string
}

// ===== [ Implementations ] =====

// ===== [ Private Functions ] =====

// ===== [ Public Functions ] =====
