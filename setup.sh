#!/bin/bash

# Clear old setups
mv Dockerfiles/client/ Dockerfiles/client-delete/
mkdir Dockerfiles/client/

# Keep Dockerfile and dockerignore
mv Dockerfiles/client-delete/Dockerfile Dockerfiles/client/
mv Dockerfiles/client-delete/.dockerignore Dockerfiles/client/

rm -rf Dockerfiles/client-delete/

mv Dockerfiles/user-auth/ Dockerfiles/user-auth-delete/
mkdir Dockerfiles/user-auth/

# Keep Dockerfile and dockerignore
mv Dockerfiles/user-auth-delete/Dockerfile Dockerfiles/user-auth/
mv Dockerfiles/user-auth-delete/.dockerignore Dockerfiles/user-auth/

rm -rf Dockerfiles/user-auth-delete/

mv Dockerfiles/user-crud/ Dockerfiles/user-crud-delete/
mkdir Dockerfiles/user-crud/

# Keep Dockerfile and dockerignore
mv Dockerfiles/user-crud-delete/Dockerfile Dockerfiles/user-crud/
mv Dockerfiles/user-crud-delete/.dockerignore Dockerfiles/user-crud/

rm -rf Dockerfiles/user-crud-delete/

# Clone Microservices
git clone git@github.com:andromia/cvrp-client.git
git clone git@github.com:andromia/cvrp-user-auth.git
git clone git@github.com:andromia/cvrp-user-crud.git

# Move projects into correct directorys
cp -r cvrp-client/* Dockerfiles/client/
cp -r cvrp-user-auth/* Dockerfiles/user-auth/
cp -r cvrp-user-crud/* Dockerfiles/user-crud/

# Clean up git clones
rm -rf cvrp-client
rm -rf cvrp-user-auth
rm -rf cvrp-user-crud
