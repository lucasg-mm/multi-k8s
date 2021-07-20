#!/usr/bin/env bash

# build images and tag them
docker build -t lucasgmm20/multi-client:latest -t lucasgmm20/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t lucasgmm20/multi-server:latest -t lucasgmm20/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t lucasgmm20/multi-worker:latest -t lucasgmm20/multi-worker:$SHA -f ./worker/Dockerfile ./worker


# push images (with every tag) to Docker Hub
docker push lucasgmm20/multi-client:latest
docker push lucasgmm20/multi-client:$SHA

docker push lucasgmm20/multi-server:latest
docker push lucasgmm20/multi-server:$SHA

docker push lucasgmm20/multi-worker:latest
docker push lucasgmm20/multi-worker:$SHA


# apply kubes' config files
kubectl apply -f k8s

# updates images used in kubes' deployments
kubectl set image deployments/client-deployment client=lucasgmm20/multi-client:$SHA
kubectl set image deployments/server-deployment server=lucasgmm20/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=lucasgmm20/multi-worker:$SHA