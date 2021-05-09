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
# entrypoint 脚本方式，会将脚本本身作为1号进程
# 因此在脚本末尾需要启动服务！！！
# 否则1号进程执行完脚本就退出了，连带着容器一起退出
rabbitmq-server 