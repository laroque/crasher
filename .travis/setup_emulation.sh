#!/usr/bin/env bash

echo "hey there, I am `whoami`"

echo '{"experimental":true}' >> /etc/docker/daemon.json
service docker restart
