#!/usr/bin/env bash

# build images and tag them
docker build -t lucasg-mm/multi-client:latest -t lucasg-mm/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t lucasg-mm/multi-server:latest -t lucasg-mm/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t lucasg-mm/multi-worker:latest -t lucasg-mm/multi-worker:$SHA -f ./worker/Dockerfile ./worker


# push images (with every tag) to Docker Hub
docker push lucasg-mm/multi-client:latest
docker push lucasg-mm/multi-client:$SHA

docker push lucasg-mm/multi-server:latest
docker push lucasg-mm/multi-server:$SHA

docker push lucasg-mm/multi-worker:latest
docker push lucasg-mm/multi-worker:$SHA


# apply kubes' config files
kubectl apply -f k8s

# updates images used in kubes' deployments
kubectl set image deployments/client-deployment client=lucasg-mm/multi-client:$SHA
kubectl set image deployments/server-deployment server=lucasg-mm/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=lucasg-mm/multi-worker:$SHA