#!/bin/bash

docker build -t enzobarrett/multi-client:latest -t enzobarrett/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t enzobarrett/multi-server:latest -t enzobarrett/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t enzobarrett/multi-worker:latest -t enzobarrett/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push enzobarrett/multi-client:latest
docker push enzobarrett/multi-server:latest
docker push enzobarrett/multi-worker:latest

docker push enzobarrett/multi-client:$SHA
docker push enzobarrett/multi-server:$SHA
docker push enzobarrett/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=enzobarrett/multi-server:$SHA
kubectl set image deployments/client-deployment client=enzobarrett/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=enzobarrett/multi-worker:$SHA
