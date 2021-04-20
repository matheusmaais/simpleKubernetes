#!/bin/bash
echo -e 'Creating resources'
echo -e '------------------------------------'
kubectl apply -f namespaces.yaml
sleep 1
kubectl apply -f DeploymentTest.yaml
sleep 1
kubectl apply -f nodeport.yaml
sleep 2

echo -e '\nScaling Deployment to 5 replicas'
echo -e '------------------------------------'
kubectl config set-context --current --namespace=test
kubectl scale deployment docker-demo --replicas=5  --record
sleep 1

echo -e '\nShow Deployment history'
kubectl rollout history deploy docker-demo
echo -e '------------------------------------\n'

echo -e '\nShowing pod Ips and status'
sleep 5
kubectl get pods -n test  -o=custom-columns="NAME:.metadata.name,IP:.status.podIP,Status:.status.phase"

echo -e "\nYou can access aplication in:"
NODEIP=$(kubectl get nodes --no-headers -o=custom-columns=":.status.addresses[0].address")
NODEPORT=":30001"
NODEIP+=$NODEPORT

echo "http://$NODEIP"


