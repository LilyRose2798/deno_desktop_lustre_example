# Deno Desktop Lustre Example

An example Gleam project that shows how to use `deno desktop` to run a Lustre application as a desktop app.

## Development

First build and bundle the client application:

```sh
cd client
gleam build
deno bundle -o ../server/public/client.js entry.js # optionally add --minify
cd ..
```

Then build and run the server application:

```sh
cd server
gleam build
deno desktop --no-check --allow-all --include public --hmr serve.js # optionally add --backend cef
```

When building an executable to distribute you may also want to bundle the server application:

```sh
cd server
gleam build
deno bundle -o server-bundle.js serve.js
deno desktop --no-check --allow-all --include public -o dist server-bundle.js # optionally add --minify
```

The server can also be run as a regular web server, with the Lustre application viewable in a browser:

```sh
cd server
gleam build
deno serve --allow-all serve.js # or bun serve.js
```
