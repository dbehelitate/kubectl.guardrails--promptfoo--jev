## Deploying Agentgateway Policy

Inspect the complete policy definition in `manifests/05-agentgateway-policy.yaml`:

~~~yaml
apiVersion: security.agentgateway.dev/v1alpha1
kind: AgentgatewayPolicy
metadata:
  name: llm-strict-guardrails
  namespace: default
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: llm-mock-route
  rules:
    # 1. Custom Regex - Block Prompt Injection
    - name: block-prompt-injection
      scope: Messages
      match:
        regex: 
          - "(?i)ignore all previous instructions"
          - "(?i)reveal system keys"
          - "(?i)bypass protocol"
      action: Reject
      message: "Security Alert: Prompt injection detected."
      statusCode: 403

    # 2. Built-in PII Rejection
    - name: block-pii-inputs
      scope: Messages
      match:
        builtins: ["Email", "PhoneNumber", "Ssn", "CaSin"]
      action: Reject
      message: "Privacy Alert: Prohibited PII detected in prompt."
      statusCode: 400

    # 3. Output Masking / Redaction
    - name: mask-sensitive-outputs
      scope: ToolOutput
      match:
        builtins: ["CreditCard"]
      action: Mask
      maskCharacter: "*"
~~~

Apply the policy to activate guardrails on the HTTPRoute:

`kubectl apply -f manifests/05-agentgateway-policy.yaml`{{exec}}

Verify policy status and confirm it is accepted:

`kubectl describe agentgatewaypolicy llm-strict-guardrails`{{exec}}

`kubectl get agentgatewaypolicy llm-strict-guardrails`{{exec}}
