# devops-portfolio Technique
🛠️ Projets DevOps Kubernetes + Terraform pour démontrer mes compétences

Bienvenue dans mon laboratoire DevOps. Ce dépôt me permet de démontrer mes compétences en :

- 🚀 Déploiement Kubernetes
- 📦 Helm & Kustomize
- 🔄 GitLab CI/CD & Concourse
- 🔧 Prochainement : Terraform & infrastructure as code

---

## 📁 Structure du dépôt

| Dossier          | Contenu                                                              |
|------------------|----------------------------------------------------------------------|
| `helm/`          | Charts Helm pour déploiement d'applications (ex: CronJob applicatif) |
| `kustomize/`     | Overlays pour différents environnements (staging, prod…)             |
| `gitlab-ci/`     | Pipelines GitLab CI/CD réutilisables                                 |
| `concourse-ci/`  | Pipelines Concourse réutilisables                                    |
| `images-docker/` | Images dockers réutilisables                                         |
| `terraform/`     | *À venir* : provisionnement d’infrastructure Cloud                   |

---

## 📌 Objectif

Créer un portfolio technique DevOps illustrant ma capacité à :
- Concevoir, déployer et maintenir des environnements K8s
- Automatiser des déploiements CI/CD
- Documenter, versionner et rendre réutilisable mon travail
- Monter en puissance sur l’**infra as code avec Terraform**

---

## ✅ Projets inclus

### 1. 🕑 Helm – CronJob applicatif

- 📁 `helm/cronjob-demo`
- 📄 `values.yaml` personnalisable
- ⚙️ Déploiement via `helm install`

### 2. 🧩 Kustomize – Overlays staging

- 📁 `kustomize/overlays/staging/`
- Contient un `deployment.yaml`, `service.yaml`, `hpa.yaml`

### 3. 🌀 GitLab CI – Pipeline modulaire

- 📄 `.gitlab-ci.yml` avec stages : `build`, `test`, `deploy`
- Intégration avec `kubectl`, `helm`, et `kustomize`

### 4. 🐳 Docker – Images personnalisées

- 📁 `docker/nginx-ssl-proxy`
- Contient un `Dockerfile` documenté
- Usage : reverse proxy sécurisé pour déploiement K8s

### 5. 🏗️ Concourse CI – Pipelines déclaratifs

- 📁 `concourse-ci/`
- `templates/` pour jobs réutilisables
- `pipelines/` pour des exemples concrets (build, test, deploy)

---

## 📚 À venir

- [ ] Infrastructure AWS via Terraform
- [ ] Création de cluster EKS + déploiement automatisé
- [ ] CI/CD full-stack (Terraform + K8s + Helm)

---

## 👨‍💻 Auteur

> [Henri-Frank] – Ingénieur IT | Fullstack & DevOps  
> 🔗 [https://www.linkedin.com/in/henri-frank-anaba-22721b7a/]  

[//]: # (> 📬 Contact en DM pour missions ou échanges techniques)

---

## 📜 Licence

MIT – libre d’utilisation à des fins pédagogiques ou techniques
