# 📦 common-pipeline

Ce projet contient une collection de templates GitLab CI réutilisables pour automatiser les pipelines des projets backend, 
principalement basés sur Quarkus, Maven, Docker et Helm.

## 📁 Structure du projet

```text
common-pipeline/
├── variables/
│   └── defaults.yml              # Variables globales (registry, image Maven, timeouts, etc.)
│
├── templates/
│   ├── semantic-release.yml      # Versioning sémantique (semantic-release)
│   ├── sonar.yml                 # Analyse statique de code avec SonarQube
│   ├── build-image.yml           # Compilation et publication d'image Docker
│   ├── deploy-environment.yml    # Déploiement Helm (dev, va, prod)
│   ├── test-e2e.yml              # Exécution des tests end-to-end
│   └── test-mvn.yml              # Tests unitaires Maven
│
└── README.md                     # Documentation du projet
```


---

## 🚀 Comment l’utiliser dans un projet

Dans le projet cible (ex: `backend-java`), créer un `.gitlab-ci.yml` avec :

```yaml
include:
  - project: devops-portfolio/gitlab-ci/common-pipeline
    ref: master
    file: gitlab-ci-quarkus.yml


variables:
  IMAGE_NAME: "backend-java"
  URL_REPOS: "https://github.com/zlatan-ibrahimovic/devops-portfolio.git"
  SONAR_PROJECT_KEY: backend_java_key
  HELM_RELEASE_NAME: backend-java

```

## 🚀 Template générique pour projets Java (gitlab-ci-quarkus.yml)

Ce projet propose un template GitLab CI réutilisable et prêt à l’emploi pour les projets Java/Maven déployés sur
Kubernetes via Helm. Il inclut l'intégration de Sonar, la génération et le push d'image Docker, les tests unitaires,
les tests E2E, le versioning sémantique et le déploiement sur différents environnements.

### 🧱 Stages gérés

| Stage                     | Description                                          |
| ------------------------- | ---------------------------------------------------- |
| `semantic-release`        | Gère le versioning sémantique via `semantic-release` |
| `build-and-publish-image` | Compile, teste et publie l'image Docker              |
| `dev`, `va`, `prod`       | Déploiements Helm et tests E2E par environnement     |


### ✅ Jobs inclus

    Analyse Sonar (sonar-analysis-and-security-analysis)

    Tests Maven (build-test-with-mvn)

    Build + push image Docker (build-and-publish-image)

    Déploiements Helm (helm-deployment-*)

    Tests E2E (e2e-*)

## ⚙️ Variables disponibles
Par défaut (variables/defaults.yml)

| Variable                    | Description                                                                   |
|-----------------------------|-------------------------------------------------------------------------------|
| `IMAGE_REGISTRY`            | URL du registre Docker utilisé pour les builds                                |
| `MAVEN_IMAGE`               | Image Docker utilisée pour les étapes Maven                                   |
| `HELM_IMAGE`                | Image Docker utilisée pour les commandes Helm                                 |
| `IMAGE_NAME`                | Nom de l’image Docker (à définir dans le projet)                              |
| `TEAM_NAME`                 | Nom de l’équipe ou du namespace GitLab                                        |
| `CI_PIPELINE_TIMEOUT`       | Timeout maximal d’un pipeline GitLab CI                                       |
| `NPM_REGISTRY`              | URL du registre NPM interne                                                   |
| `DOCKER_DRIVER`             | Driver Docker utilisé                                                         |
| `KUBECONFIG_CLUSTER_DEV`         | Secret Conjur pour le kubeconfig de l’environnement CLUSTER DEV                    |
| `KUBECONFIG_CLUSTER_PREPROD`     | Secret Conjur pour le kubeconfig de l’environnement CLUSTER PREPROD                |
| `KUBECONFIG_CLUSTER_PROD`        | Secret Conjur pour le kubeconfig de l’environnement CLUSTER PROD                   |
| `DOCKER_REGISTRY_URL`       | URL du registre Docker pour les push                                          |
| `DOCKER_HOST`               | Adresse du démon Docker utilisé dans le runner                                |
| `HELM_CHART_REPO`           | Chemin du chart Helm à utiliser (dans le repo Docker)                         |
| `HELM_VERSION`              | Version de Helm utilisée dans le pipeline                                     |
| `TIMEOUT`                   | Timeout des commandes Helm ou Kubectl spécifiques (ex: `helm upgrade`)        |
| `KEY_PEM`                   | Clé privée PEM injectée via variable d’environnement sécurisée (`${KEY_PEM}`) |


Tu peux surcharger n'importe quelle variable dans le .gitlab-ci.yml du projet.


## 🧩 Templates disponibles
- **semantic-release.yml**:
    Crée automatiquement des tags et versions via les commits conventionnels (feat:, fix:, etc.).
    Fonctionne uniquement sur la branche main.

- **sonar.yml**:
    Lance SonarQube avec Maven (via mvn verify sonar:sonar) sauf sur main.

- **build-image.yml**:
    Construit et push l’image Docker (docker build/push) avec un tag automatique (SHA ou autre).

- **deploy-environment.yml**:
    Déploie dans un environnement donné (dev, va, prod...) avec Helm.
    Nécessite un chart dans le dossier deploy/helm.

- **test-e2e.yml**:
    Tests e2e sur les environnements de dev et va.

- **test-mvn.yml**:
    Tests maven (mvn clean test) sur les branches features et sur la branch master.


## ✅ Bonnes pratiques
Utiliser les commits conventionnels (feat:, fix:, chore:…) pour tirer parti de semantic-release.
  Ne pas dupliquer les templates entre projets : tout changement se fait ici dans common-pipeline.
  Versionner le ref: main avec un tag (ref: v1.0.0) pour plus de stabilité.