REGISTRY ?= ghcr.io/yourname
RELEASE ?= demo
CHART   ?= charts/webapp
NAMESPACE ?= webapp

.PHONY: deps lint template install upgrade test package kind

deps:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm dependency update $(CHART)

lint:
	helm lint $(CHART)

template:
	helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(CHART)/values.yaml

install: deps
	kubectl create ns $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	helm install $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(CHART)/values-dev.yaml --create-namespace --wait

upgrade:
	helm upgrade $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(CHART)/values-prod.yaml --install --atomic --wait

test:
	helm unittest $(CHART)

package:
	helm package $(CHART) -d dist/

kind:
	kind create cluster --name helm-demo || true
