# Déploiement de Uptime Kuma sur les clusters gxx : `cluster-test` et `cluster-final-bdx`

Ce guide explique comment déployer **Uptime Kuma** sur un namespace donné d'un cluster Kubernetes donné.

---

## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants configurés :

1. **Accès au cluster Kubernetes** :
    - Vous devez être connecté au cluster `cluster-test` ou `cluster-final-bdx`.
    - Testez la connexion avec la commande suivante :
      ```bash
      kubectl get nodes
      ```

2. **Traefik et Cert-Manager** :
    - Le cluster doit avoir un **Ingress Controller** (comme Traefik) et un **Cluster Issuer** configurés.

3. **Stockage persistant** :
    - Un provisionneur de volumes persistants doit être disponible pour gérer les `PersistentVolumeClaims`.

---

## Déploiement

### Étape 1 : Télécharger le fichier YAML
Assurez-vous d'avoir le fichier `uptime-kuma-deployment.yaml` correspondant à l'environnement cible. Placez-le dans un répertoire local.

### Étape 2 : Appliquer les configurations

```bash
kubectl apply -f uptime-kuma-final.yaml
```

😊
