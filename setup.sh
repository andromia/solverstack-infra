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
git clone git@github.com:andromia/solverstack-client.git
cp -r solverstack-client/* .
rm -rf solverstack-client
cd ..

cd user-auth/
git clone git@github.com:andromia/solverstack-user-auth.git
cp -r solverstack-user-auth/* .
rm -rf solverstack-user-auth
cd ..

cd user-crud/
git clone git@github.com:andromia/solverstack-user-crud.git
cp -r solverstack-user-crud/* .
rm -rf solverstack-user-crud
cd ..
