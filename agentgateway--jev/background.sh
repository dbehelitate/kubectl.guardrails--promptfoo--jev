#!/bin/bash
# Install Agentgateway CRDs
kubectl apply -f https://raw.githubusercontent.com/agentgateway/agentgateway/main/manifests/crds.yaml

# Apply local manifests
kubectl apply -f manifests/jev-webhook-deployment.yaml
kubectl apply -f manifests/mock-llm-deployment.yaml
kubectl apply -f manifests/gateway-config.yaml

# Wait for deployments to be ready
kubectl wait --for=condition=available --timeout=60s deployment/jev-webhook
kubectl wait --for=condition=available --timeout=60s deployment/mock-llm
kubectl wait --for=condition=available --timeout=120s deployment/agentgateway

# Signal readiness to foreground.sh
touch /tmp/background_ready
