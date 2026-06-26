#!/bin/sh

gleam build && deno bundle -o ../server/public/client.js entry.js
