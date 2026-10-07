# Welcome to Agentgateway Security on Kubernetes

In this interactive scenario, you will deploy **Agentgateway** as a Kubernetes-native reverse proxy using the Gateway API to apply multi-layered security to an AI model pipeline.

### Objectives
1. **Request Prompt Injection & Custom Regex**: Intercept and reject malicious prompts.
2. **Built-in PII Detection**: Block prompts containing SSNs, phone numbers, or emails.
3. **Response Masking / Sanitization**: Intercept outputs to redact credit card numbers.
4. **Gateway API Inspection**: Use `gwctl` to trace policy attachments.
5. **Automated Guardrail Testing**: Run continuous security evaluations with `Promptfoo`.

Click **Start Scenario** to begin!
