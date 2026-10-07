## Gateway API Inspection: `gwctl`

`gwctl` is the official Kubernetes SIGs tool to inspect Gateway API resources and attached policies.

### 1. Install `gwctl` CLI
`curl -fL -o gwctl-linux-amd64 https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/gwctl-linux-amd64`{{exec}}

`chmod +x gwctl-linux-amd64 && sudo mv gwctl-linux-amd64 /usr/local/bin/gwctl`{{exec}}

### 2. Inspect Policy Attachment
Verify hierarchy and attached `AgentgatewayPolicy` using `gwctl`:

`gwctl describe httproute llm-mock-route`{{exec}}

Scroll through the output and look for the **Policies** section. You will see `AgentgatewayPolicy/llm-strict-guardrails` correctly bound to the route.
