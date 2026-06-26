#!/bin/sh

deno bundle -o server-bundle.js serve.js && deno desktop --no-check --allow-all --include public -o dist server-bundle.js
