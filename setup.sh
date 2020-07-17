#!/bin/bash

# Clean up
cd Dockerfiles
mv web-client/Dockerfile web-client/.dockerignore . && rm -rf web-client/*
mv Dockerfile .dockerignore web-client/

cd Dockerfiles
mv user-auth/Dockerfile user-auth/.dockerignore . && rm -rf user-auth/*
mv Dockerfile .dockerignore user-auth/

cd Dockerfiles
mv user-crud/Dockerfile user-crud/.dockerignore . && rm -rf user-crud/*
mv Dockerfile .dockerignore user-crud/

cd Dockerfiles
mv vrp-rpc/Dockerfile vrp-rpc/.dockerignore . && rm -rf vrp-rpc/*
mv Dockerfile .dockerignore vrp-rpc/

# Clone Microservices
cd web-client/
git clone git@github.com:andromia/solverstack-web-client.git
cp -r solverstack-web-client/* .
rm -rf solverstack-web-client
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

cd vrp-rpc/
git clone git@github.com:andromia/solverstack-vrp-rpc.git
cp -r solverstack-vrp-rpc/* .
rm -rf solverstack-vrp-rpc
cd ..
