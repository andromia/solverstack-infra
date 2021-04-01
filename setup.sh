#!/bin/bash

# Clean up
cd Dockerfiles
mv web/Dockerfile web/.dockerignore . && rm -rf web/*
mv Dockerfile .dockerignore web/

cd Dockerfiles
mv route/Dockerfile route/.dockerignore . && rm -rf route/*
mv Dockerfile .dockerignore route/

# Clone Services
cd web/
git clone git@github.com:cnpls/solverstack-web.git
cp -r solverstack-web/* .
rm -rf solverstack-web
cd ..

cd route/
git clone git@github.com:cnpls/solverstack-route.git
cp -r solverstack-route/* .
rm -rf solverstack-route
cd ..
