#!/bin/bash

docker stop tf
docker rm tf
docker run -d --name tf -v /lib/modules:/lib/modules -v $HOME/dl_examples:/home/tf/dl_examples -p 999:22 -p 8888:8888 --privileged ubuntu:18.04-tf-gpu
