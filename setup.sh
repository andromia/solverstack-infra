#!/bin/bash

# Clean up
cd Dockerfiles
mv client/Dockerfile client/.dockerignore . && rm -rf client/*
mv Dockerfile .dockerignore client/

cd Dockerfiles
mv user-auth/Dockerfile user-auth/.dockerignore . && rm -rf user-auth/*
mv Dockerfile .dockerignore user-auth/

cd Dockerfiles
mv user-crud/Dockerfile user-crud/.dockerignore . && rm -rf user-crud/*
mv Dockerfile .dockerignore user-crud/

# Clone Microservices
cd client/
git clone git@github.com:andromia/cvrp-client.git
cp -r cvrp-client/* .
rm -rf cvrp-client
cd ..

cd user-auth/
git clone git@github.com:andromia/cvrp-user-auth.git
cp -r cvrp-user-auth/* .
rm -rf cvrp-user-auth
cd ..

cd user-crud/
git clone git@github.com:andromia/cvrp-user-crud.git
cp -r cvrp-user-crud/* .
rm -rf cvrp-user-crud
cd ..
