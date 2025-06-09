# Documentation du Serveur Lighthouse

## Introduction

Dans le cadre de l'écoconception des applications, l'analyse des performances des sites web et des applications 
constitue une étape essentielle pour optimiser leur impact écologique. Le serveur Lighthouse (Lighthouse CI Server) 
joue un rôle crucial dans cette démarche en permettant de centraliser les rapports de performances générés par l'outil 
Lighthouse. Ce serveur fournit une infrastructure fiable pour suivre les évolutions des scores de performance, 
accessibilité, SEO, et meilleures pratiques d'une application au fil du temps.

### Finalité du Serveur Lighthouse

Le serveur Lighthouse permet de :
- Collecter et centraliser les rapports d'analyse Lighthouse dans un environnement collaboratif.
- Suivre les performances des applications dans le temps.
- Faciliter l'intégration de l'écoconception dans les pipelines CI/CD.
- Identifier rapidement les régressions de performance ou les problèmes de conformité.

## Écoconception et Apport du Serveur Lighthouse

L'écoconception vise à réduire l'impact environnemental des applications à travers des choix techniques et 
fonctionnels optimisés. En mesurant de manière continue les indicateurs de performance, le serveur Lighthouse 
contribue à :
- Réduire la consommation d'énergie des applications.
- Améliorer l'efficacité des interfaces utilisateur.
- Promouvoir des pratiques de développement durable et responsables.

## Éléments Kubernetes Nécessaires pour le Déploiement

Pour déployer le serveur Lighthouse sur Kubernetes, plusieurs ressources sont à configurer :

### Namespace

Le namespace sépare les ressources associées au serveur Lighthouse des autres applications :
```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    environnement: test
  name: mamespace-test
```
### Service
Expose le serveur Lighthouse à l'intérieur du cluster Kubernetes :

```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    equipe: henriFrank
  name: lhci-server-service
  namespace: mamespace-test
spec:
  ports:
  - port: 9001
    protocol: TCP
    targetPort: 9001
  selector:
    app: lhci-server
```
### PersistentVolumeClaim (PVC)
Permet de stocker les données du serveur de manière persistante :

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: lhci-data-pvc
  namespace: mamespace-test
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
      
```

### Deployment
Définit les pods exécutant l'application Lighthouse Server :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lhci-server
  namespace: mamespace-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: lhci-server
  template:
    metadata:
      labels:
        app: lhci-server
    spec:
      containers:
      - image: build.repository/lhci-server:VERSION_IMAGE
        name: lhci-server
        ports:
        - containerPort: 9001
        volumeMounts:
        - mountPath: /data
          name: lhci-data
      volumes:
      - name: lhci-data
        persistentVolumeClaim:
          claimName: lhci-data-pvc
```
### Ingress
Expose le serveur Lighthouse à l'extérieur du cluster :

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: lhci-ingress
  namespace: mamespace-test
spec:
  rules:
  - host: lighthouse-server-gxx.cluster-test.k8s.home.intra
    http:
      paths:
      - backend:
          service:
            name: lhci-server-service
            port:
              number: 9001
        path: /
        pathType: Prefix
```
En résumé, ce déploiement sur Kubernetes fournit une infrastructure fiable et extensible 
pour exploiter les rapports Lighthouse et contribuer à une démarche d'écoconception ambitieuse et durable.

# CREATION DE PROJET 
La création de projet est décrite [ici](Install.md) 