#!/bin/bash

# Nom de la cible Concourse (à adapter selon ta config)
TARGET_NAME="devops-lab"
PIPELINE_NAME="build-docker"
PIPELINE_FILE="pipelines/build-docker.yml"
VARS_FILE="params/docker-build-params.yml"

# Vérifie que fly est installé
if ! command -v fly &> /dev/null; then
  echo "❌ fly CLI non trouvé. Installe-le depuis https://concourse-ci.org/fly.html"
  exit 1
fi

# Login vers Concourse (à adapter selon ton URL/teams)
fly --target $TARGET_NAME login \
  --concourse-url https://ci.example.com \
  --team-name main

# Set/update du pipeline
fly --target $TARGET_NAME set-pipeline \
  --pipeline $PIPELINE_NAME \
  --config $PIPELINE_FILE \
  --var-file $VARS_FILE \
  --non-interactive

# Unpause le pipeline
fly --target $TARGET_NAME unpause-pipeline --pipeline $PIPELINE_NAME

echo "✅ Pipeline '$PIPELINE_NAME' déployé sur la cible '$TARGET_NAME'"
