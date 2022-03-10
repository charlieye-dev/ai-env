#!/bin/bash

docker run -d --name ai -v /lib/modules:/lib/modules -p 999:22 -p 8888:8888 --privileged ubuntu:18.04-ai-gpu
