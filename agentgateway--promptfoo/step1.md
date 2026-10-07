## Environment Provisioning

Install the official Kubernetes Gateway API CRDs:

`kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd/experimental?ref=v1.0.0"`{{exec}}

Deploy the Agentgateway Control Plane via Helm:

`helm repo add agentgateway https://charts.agentgateway.dev && helm repo update && echo "Helm repo setup complete"`{{exec}}

`helm install agentgateway agentgateway/agentgateway --namespace agentgateway-system --create-namespace --wait`{{exec}}

## Deploying Mock AI Backend (`httpbun`) & Gateway Resources

### 1. Deployment & Service

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbun
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpbun
  template:
    metadata:
      labels:
        app: httpbun
    spec:
      containers:
      - name: httpbun
        image: sharat87/httpbun
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: httpbun
  namespace: default
spec:
  selector:
    app: httpbun
  ports:
  - port: 80
    targetPort: 80
~~~

Apply Deployment and Service:

`kubectl apply -f manifests/01-httpbun-deployment.yaml`{{exec}}

`kubectl apply -f manifests/02-httpbun-service.yaml`{{exec}}

Wait for the deployment rollout (max 30 seconds):

`kubectl rollout status deployment/httpbun --timeout=30s`{{exec}}

---

### 2. Gateway & HTTPRoute

~~~yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: agentgateway-main
  namespace: default
spec:
  gatewayClassName: agentgateway
  listeners:
  - name: http
    protocol: HTTP
    port: 8080
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: llm-mock-route
  namespace: default
spec:
  parentRefs:
  - name: agentgateway-main
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /v1/chat/completions
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplaceFullPath
          replaceFullPath: /post
    backendRefs:
    - name: httpbun
      port: 80
~~~

Apply Gateway and HTTPRoute:

`kubectl apply -f manifests/03-gateway.yaml`{{exec}}

`kubectl apply -f manifests/04-httproute.yaml`{{exec}}

Wait for the Gateway to be ready:

`kubectl wait --for=condition=ready gateway/agentgateway-main --timeout=30s 2>/dev/null || kubectl describe gateway/agentgateway-main`{{exec}}

Verify route binding:

`kubectl get httproute llm-mock-route`{{exec}}
