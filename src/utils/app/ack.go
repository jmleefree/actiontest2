package app

import (
	"errors"
	"fmt"

	"github.com/beego/beego/v2/core/validation"
	"github.com/jmleefree/actiontest2/src/core/model"
	"github.com/jmleefree/actiontest2/src/utils/config"
	"github.com/jmleefree/actiontest2/src/utils/lang"
	"github.com/labstack/echo/v4"
)

type Status struct {
	Message string `json:"message"`
}

func SendMessage(c echo.Context, httpCode int, msg string) error {
	return c.JSON(httpCode, Status{Message: msg})
}

func Send(c echo.Context, httpCode int, json interface{}) error {
	return c.JSON(httpCode, json)
}

func Validate(c echo.Context, params []string) error {
	valid := validation.Validation{}

	for _, name := range params {
		valid.Required(c.Param(name), name)
	}

	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return errors.New(fmt.Sprintf("[%s]%s", err.Key, err.Error()))
		}
	}
	return nil
}

func ClusterReqDef(clusterReq model.ClusterReq) {
	clusterReq.Config.Kubernetes.NetworkCni = lang.NVL(clusterReq.Config.Kubernetes.NetworkCni, config.NETWORKCNI_KILO)
	clusterReq.Config.Kubernetes.PodCidr = lang.NVL(clusterReq.Config.Kubernetes.PodCidr, config.POD_CIDR)
	clusterReq.Config.Kubernetes.ServiceCidr = lang.NVL(clusterReq.Config.Kubernetes.ServiceCidr, config.SERVICE_CIDR)
	clusterReq.Config.Kubernetes.ServiceDnsDomain = lang.NVL(clusterReq.Config.Kubernetes.ServiceDnsDomain, config.SERVICE_DOMAIN)
}

func ClusterReqValidate(req model.ClusterReq) error {
	if len(req.ControlPlane) == 0 {
		return errors.New("control plane node must be at least one")
	}
	if len(req.Worker) == 0 {
		return errors.New("worker node must be at least one")
	}
	if !(req.Config.Kubernetes.NetworkCni == config.NETWORKCNI_CANAL || req.Config.Kubernetes.NetworkCni == config.NETWORKCNI_KILO) {
		return errors.New("network cni allows only Kilo or Canal")
	}
	return nil
}

func NodeReqValidate(req model.NodeReq) error {
	if len(req.ControlPlane) > 0 {
		return errors.New("control plane node not supported")
	}
	if len(req.Worker) == 0 {
		return errors.New("worker node count must be at least one")
	}

	return nil
}
