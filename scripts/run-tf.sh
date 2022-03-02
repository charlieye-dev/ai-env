#!/bin/bash

docker stop tf
docker rm tf
docker run -d --name tf -v /lib/modules:/lib/modules -p 999:22 -p 8888:8888 --privileged ubuntu:18.04-tf-gpu
