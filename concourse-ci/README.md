# 🔧 Concourse CI Pipelines – DevOps Lab

Ce dossier contient des pipelines et des templates prêts à l'emploi pour automatiser vos déploiements et tests dans un environnement Kubernetes.

---

## 📁 Structure

concourse-ci/
├── pipelines/ # Pipelines prêts à l'emploi
├── templates/ # Jobs/tasks réutilisables
├── params/ # Fichiers de paramètres injectables
└── scripts/ # Scripts fly pour déployer les pipelines


---

## 🚀 Déploiement d'un pipeline

1. **Configurer la cible Concourse** dans `scripts/deploy-pipeline.sh`
2. **Lancer le déploiement** :

```bash
./scripts/deploy-pipeline.sh
