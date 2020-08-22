# Resume Name Remover Frontend

For this to work, the [backend](../backend) needs to be running on [localhost:8080](http://localhost:8080).

To start the server in development mode on [localhost:3000](http://localhost:3000):

```
make start_development
```

To start the server in production mode, run `make start` from the root (since both the frontend and backend containers need to run in the same network, provided by `docker-compose`).

To run all tests:

```
make test
```
