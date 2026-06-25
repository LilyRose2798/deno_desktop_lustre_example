# Deno Desktop Lustre Example

An example Gleam project that shows how to use `deno desktop` to run a Lustre application as a desktop app.

## Development

First build and bundle the client application:
```sh
cd client
gleam build
deno bundle -o ../server/static/client.js entry.js
cd ..
```

Then build and run the server application:
```sh
cd server
gleam build
deno desktop --no-check --allow-all --hmr serve.js # remove --hmr to save built executable
```

The server can also be run as a regular web server, with the Lustre application viewable in a browser:
```sh
cd server
gleam build
deno serve --allow-all serve.js # or bun serve.js
```
