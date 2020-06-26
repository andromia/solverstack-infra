# cvrp-infra
Infrastructure related scripts and tools

### Initial setup
Run the following command to setup the directory
```
sh setup.sh
```

### Start Docker
Run the following command to intialize the docker compose process
```
docker-compose up --build
```

### Stop Docker
Run the following command to stop docker containers, first do ctrl+C and then:

Note: this command only needs to be run if you need to do a complete tear down. Ctrl+C should be fine most of the time.
```
docker-compose down
```

### Summary
The `setup.sh` file is cloning all the microservices into the correct directory's where the Dockerfile's live. Once all the files have been cloned, we executed the `docker-compose.yaml` file which lives in the root of the project. Running the command `docker-compose ...` looks at that file and creates all the services listed in there. The way it is structured now is there's 3 node services - one for Next.js, one for User Auth operations, and one for User Crud operations. The latter two services are connected into the same mongo database and can perform individual operations, simultaneously.