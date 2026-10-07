#!/bin/bash
echo "Waiting for the Preschool to open (Kubernetes is initializing)..."
while [ ! -f /tmp/background_ready ]; do sleep 2; done
echo "AgentGateway and Jev are awake and ready! You can begin!"
