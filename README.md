# Resume Name Remover - backend API
Attempts to reduce hiring bias by removing a candidate's name. This is a simple REST API
that accepts a PDF as input, and returns a new PDF without the candidate's name, as well
as removing formatting found in the original PDF.

To start the server in production mode:

```
make start
```

and in development mode:

```
make start_development
```

To run all tests:

```
make test
```
