#!/bin/sh
runuser -l cloud9ide -c '/home/cloud9ide/.c9/node/bin/node /home/cloud9ide/cloud9/server.js --auth $AUTH --listen 0.0.0.0 --port 8080 -w /workspace'
