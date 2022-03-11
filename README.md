A tool helps to build a deep learning docker environment quickly.

## Build

```
make <TARGET> <ARG>=1 ...
```

**TARGET** are supported following,

| Target | Image | Description |
|--------|-------|-------------|
| build-ai-cpu | ubuntu:18.04-ai-cpu | Build a docker image with tensorflow & pytorch environment. |
| build-ai-gpu | ubuntu:18.04-ai-gpu | Build a docker image with tensorflow & pytorch & cuda environment. |

**ARG** are supported following,

| Argument | Description |
|----------|-------------|
| DOWNLOAD_CUDA | Download cuda when build image |
| AUTO_VIM | Configure [autoVim](https://github.com/yechenglin-dev/autoVim) in image |
| CHINA | Configure [china](https://github.com/yechenglin-dev/china-source.git) source list for apt & pip |

## Usage

Run a image,

```
docker run -d -v /lib/modules:/libmodules --privileged --name -p 999:22 ai <IMAGE>
```

Login container via ssh,

```
ssh -p 999 ai@localhost
```

> Password is **testpass**.
