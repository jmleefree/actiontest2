module github.com/jmleefree/actiontest2

go 1.16

replace (
	//github.com/coreos/bbolt => go.etcd.io/bbolt v1.3.3
	github.com/coreos/go-systemd => github.com/coreos/go-systemd/v22 v22.0.0
	google.golang.org/grpc => google.golang.org/grpc v1.26.0
)

require (
	bou.ke/monkey v1.0.2
	github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751
	github.com/beego/beego/v2 v2.0.1
	github.com/cloud-barista/cb-log v0.3.1
	github.com/cloud-barista/cb-spider v0.3.13
	github.com/cloud-barista/cb-store v0.3.14
	github.com/cloud-barista/cb-tumblebug v0.3.7 // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/dustin/go-humanize v1.0.0 // indirect
	github.com/go-resty/resty/v2 v2.6.0
	github.com/gogo/protobuf v1.3.2
	github.com/golang/protobuf v1.5.2
	github.com/google/uuid v1.2.0
	github.com/grpc-ecosystem/go-grpc-middleware v1.3.0
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/labstack/echo/v4 v4.3.0
	github.com/opentracing/opentracing-go v1.2.0
	github.com/prometheus/client_golang v1.10.0
	github.com/sirupsen/logrus v1.8.1
	github.com/spf13/cobra v1.1.3
	github.com/spf13/viper v1.7.1
	github.com/stretchr/testify v1.7.0
	github.com/swaggo/echo-swagger v1.1.0
	github.com/swaggo/swag v1.7.0
	github.com/uber/jaeger-client-go v2.29.1+incompatible
	google.golang.org/grpc v1.38.0
	gopkg.in/resty.v1 v1.12.0
	gopkg.in/yaml.v2 v2.4.0
)
