#!/bin/bash

DOCKER_REGISTRY_SERVER=https://local-harbour-repo.net
DOCKER_USER=rouslan
DOCKER_PASSWORD=50m9FiD3

kubectl create secret docker-registry my-secret --docker-server=$DOCKER_REGISTRY_SERVER --docker-username=$DOCKER_USER --docker-password=$DOCKER_PASSWORD