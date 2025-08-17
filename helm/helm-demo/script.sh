#!/usr/bin/env bash
set -euo pipefail

PROJECT=helm-demo

mkdir -p $PROJECT/{charts/webapp/{templates,tests},app}
cd $PROJECT

# Chart.yaml
cat > charts/webapp/Chart.yaml <<'EOF'
apiVersion: v2
name: webapp
version: 0.1.0
appVersion: "1.0.0"
description: Demo portfolio — Helm manipulation complète
type: application

dependencies:
  - name: redis
    version: "18.x.x"
    repository: "https://charts.bitnami.com/bitnami"
    condition: redis.enabled
EOF

# values.yaml
cat > charts/webapp/values.yaml <<'EOF'
replicaCount: 2
image:
  repository: nginx
  tag: "1.27.0"
  pullPolicy: IfNotPresent
service:
  type: ClusterIP
  port: 80
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 128Mi
ingress:
  enabled: true
  className: ""
  hosts:
    - host: demo.local
      paths:
        - path: /
          pathType: Prefix
  tls: []
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
  targetCPUUtilizationPercentage: 60
config:
  WELCOME_MESSAGE: "Hello from Helm!"
redis:
  enabled: false
EOF

# values-dev.yaml
cat > charts/webapp/values-dev.yaml <<'EOF'
image:
  tag: "1.27.0"
replicaCount: 1
ingress:
  hosts:
    - host: dev.demo.local
      paths:
        - path: /
          pathType: Prefix
redis:
  enabled: true
EOF

# values-prod.yaml
cat > charts/webapp/values-prod.yaml <<'EOF'
image:
  tag: "1.27.0"
replicaCount: 3
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
autoscaling:
  targetCPUUtilizationPercentage: 50
ingress:
  hosts:
    - host: prod.demo.local
      paths:
        - path: /
          pathType: Prefix
redis:
  enabled: true
EOF

# _helpers.tpl
cat > charts/webapp/templates/_helpers.tpl <<'EOF'
{{- define "webapp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "webapp.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
EOF

# configmap.yaml
cat > charts/webapp/templates/configmap.yaml <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "webapp.fullname" . }}-config
  labels:
    {{- include "webapp.labels" . | nindent 4 }}
data:
  WELCOME_MESSAGE: {{ .Values.config.WELCOME_MESSAGE | quote }}
EOF

# deployment.yaml
cat > charts/webapp/templates/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "webapp.fullname" . }}
  labels:
    {{- include "webapp.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Chart.Name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Chart.Name }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      containers:
        - name: web
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 80
          env:
            - name: WELCOME_MESSAGE
              valueFrom:
                configMapKeyRef:
                  name: {{ include "webapp.fullname" . }}-config
                  key: WELCOME_MESSAGE
          readinessProbe:
            httpGet:
              path: /
              port: 80
          livenessProbe:
            httpGet:
              path: /
              port: 80
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF

# service.yaml
cat > charts/webapp/templates/service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: {{ include "webapp.fullname" . }}
  labels:
    {{- include "webapp.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app.kubernetes.io/name: {{ .Chart.Name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: 80
      protocol: TCP
      name: http
EOF

# ingress.yaml
cat > charts/webapp/templates/ingress.yaml <<'EOF'
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "webapp.fullname" . }}
spec:
  ingressClassName: {{ .Values.ingress.className | default "nginx" | quote }}
  rules:
{{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
        {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ include "webapp.fullname" $ }}
                port:
                  number: {{ $.Values.service.port }}
        {{- end }}
{{- end }}
{{- end }}
EOF

# hpa.yaml
cat > charts/webapp/templates/hpa.yaml <<'EOF'
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "webapp.fullname" . }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "webapp.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
{{- end }}
EOF

# job-post-install.yaml
cat > charts/webapp/templates/job-post-install.yaml <<'EOF'
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "webapp.fullname" . }}-smoke
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  template:
    spec:
      restartPolicy: OnFailure
      containers:
        - name: curl
          image: curlimages/curl:8.8.0
          args: ["-fsS", "http://{{ include "webapp.fullname" . }}:{{ .Values.service.port }}/"]
EOF

# NOTES.txt
cat > charts/webapp/templates/NOTES.txt <<'EOF'
1. Expose l’URL via Ingress (classe: {{ .Values.ingress.className | default "nginx" }})
2. Test rapide: kubectl port-forward svc/{{ include "webapp.fullname" . }} 8080:80
3. Hook de smoke-test lancé après install/upgrade (Job + curl)
EOF

# unittest example
cat > charts/webapp/tests/deployment_test.yaml <<'EOF'
suite: Deployment
templates:
  - deployment.yaml
values:
  - ../values.yaml
asserts:
  - equal:
      path: spec.replicas
      value: 2
  - contains:
      path: spec.template.spec.containers[0].env
      content:
        name: WELCOME_MESSAGE
EOF

# Makefile
cat > Makefile <<'EOF'
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
EOF

# .gitlab-ci.yml
cat > .gitlab-ci.yml <<'EOF'
stages: [lint, test, package]

variables:
  CHART_PATH: "charts/webapp"

helm:lint:
  stage: lint
  image: alpine/helm:3.14.4
  script:
    - helm repo add bitnami https://charts.bitnami.com/bitnami
    - helm dependency update "$CHART_PATH"
    - helm lint "$CHART_PATH"

helm:unittest:
  stage: test
  image: alpine/helm:3.14.4
  before_script:
    - helm plugin install https://github.com/helm-unittest/helm-unittest
  script:
    - helm unittest "$CHART_PATH"

helm:package:
  stage: package
  image: alpine/helm:3.14.4
  script:
    - helm package "$CHART_PATH" -d dist/
  artifacts:
    paths:
      - dist/*.tgz
EOF

# app/main.go (optionnel)
cat > app/main.go <<'EOF'
package main
import (
  "fmt"
  "log"
  "net/http"
  "os"
)
func main() {
  msg := os.Getenv("WELCOME_MESSAGE")
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>%s</h1>", msg)
  })
  log.Println("listening on :8080")
  http.ListenAndServe(":8080", nil)
}
EOF

cd ..
echo "✅ Projet $PROJECT généré. Lancez 'cd $PROJECT && make kind && make install'"