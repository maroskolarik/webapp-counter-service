# webapp-counter-service
The repo for the counter service Python app.

Python service called "webapp-counter-service."

It maintains a web page with a counter for the number of POST requests it has served and return it for every GET request it gets.

--------------------------------------------------------------------
### Building and running your application

Start the application by running:
`docker compose up --build`.

The application will be available at http://localhost:80.

### Deploying your application to the cloud

First, build the image, e.g.: `docker build -t myapp .`.

Then, push it into registry, e.g. `docker push myregistry.com/myapp`.

Consult Docker's [getting started](https://docs.docker.com/go/get-started-sharing/)
docs for more detail on building and pushing.

### References
* [Docker's Python guide](https://docs.docker.com/language/python/)
