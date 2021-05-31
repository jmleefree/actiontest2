package main

import (
	"sync"

	restapi "github.com/jmleefree/actiontest2/src/rest-api"
	"github.com/jmleefree/actiontest2/src/utils/config"

	grpcserver "github.com/jmleefree/actiontest2/src/grpc-api/server"
)

// @title CB-Ladybug REST API
// @version 0.3.0-espresso
// @description CB-Ladybug REST API
// @termsOfService http://swagger.io/terms/

// @contact.name API Support
// @contact.url http://cloud-barista.github.io
// @contact.email contact-to-cloud-barista@googlegroups.com

// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html

// @host localhost:8080
// @BasePath /ladybug
func main() {

	config.Setup()

	// jmlee
	wg := new(sync.WaitGroup)

	wg.Add(2)

	go func() {
		restapi.Server()
		wg.Done()
	}()

	go func() {
		grpcserver.RunServer()
		wg.Done()
	}()

	wg.Wait()

}
