# 🛡️ Step 1: Meet the Team!

While you were waiting, we magically dropped three things into your playground:
1. **AgentGateway**: The big friendly door (listening on port `8080`).
2. **Jev Webhook**: The super-fast guard dog.
3. **Mock LLM**: The Big Storyteller AI.

Click the command below to make sure everyone is awake!
*(Killercoda Magic: You can just click the code box to run it!)*

`kubectl get pods`{{exec}}

Now, let's look at the secret instructions we gave to the door (AgentGateway). Notice the `Guardrail` rule telling the door to ask the `jev-webhook` dog before letting anyone through!

`cat manifests/gateway-config.yaml`{{exec}}
