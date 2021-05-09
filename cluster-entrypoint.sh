#!/bin/bash

set -e

# Start RMQ from entry point.
# This will ensure that environment variables passed
# will be honored
/usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached

# Wait a while for RMQ really
sleep 20s # 此处非常重要，若直接执行下面命令，会报错：rabbitmq 未运行

# Do the cluster dance
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster rabbit@rabbitmq1

# Stop the entire RMQ server. This is done so that we
# can attach to it again, but without the -detached flag
# making it run in the forground
rabbitmqctl stop

# Wait a while for the app to really stop
sleep 2s

# Start it
rabbitmq-server