# CRONJOB DEMO
Ce projet est une démo complète de manipulation Helm. 
Il met en avant les principales fonctionnalités de Helm (templating, values, dépendances, hooks, tests, CI/CD) 
et fournit une petite application de test.

# 📦 Contenu du projet

- charts/webapp/Chart.yaml : définition du chart et dépendances (Redis Bitnami).

- charts/webapp/values.yaml : valeurs par défaut.

- charts/webapp/values-dev.yaml et values-prod.yaml : overlays par environnement.

- charts/webapp/templates/ : templates Kubernetes (Deployment, Service, Ingress, ConfigMap, HPA, Job hook, etc.).

- charts/webapp/tests/ : tests unitaires Helm via helm-unittest.

- app/main.go : micro-app HTTP en Go affichant un message configurable.

- Makefile : commandes pratiques pour build/test/deployer.

- .gitlab-ci.yml : pipeline CI/CD Helm (lint, test, package).



# 🚀 Prérequis

* Docker

* Kind

* Helm 3

* kubectl

* (Optionnel) Go 1.22 pour builder l’application demo.

# ⚡ Installation

- Installer kind 
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
- Crée un cluster Kind :
```bash
make kind
```
- Installe le chart (profil dev) :

```bash
make install
```
- Upgrade en mode prod :
```bash
make upgrade
```

# 🧪 Tests

Exécuter les tests unitaires Helm :

```bash
make test
```

# 🔗 Accès à l’application

Port-forward local :

```bash
kubectl port-forward svc/demo-webapp 8080:80 -n webapp
```
Ouvrir http://localhost:8080

# 🌀 CI/CD

Un pipeline GitLab est fourni :

* Lint : validation du chart.

* Test : exécution des tests Helm.

* Package : packaging du chart en .tgz.

# 🎯 Scénarios à montrer en démo

+ Override des valeurs via -f values-dev.yaml et -f values-prod.yaml.

+ Ajout de Redis en dépendance conditionnelle.

+ Autoscaling horizontal (HPA) en prod.

+ Hook post-install de smoke-test (Job curl).

+ Rollback automatique avec --atomic en cas d’échec.