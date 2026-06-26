#!/bin/sh

gleam build && deno desktop --no-check --allow-all --include public --hmr serve.js
