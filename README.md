A tool helps to build a deep learning environment quickly.

## Build

```
make <TARGET>
```

Currently support targets following,


| Target | Image | Description |
|--------|-------|-------------|
| build-tf-gpu | ubuntu:18.04-tf-gpu | Build a docker image with tensorflow and cuda environment. |

## Usage

Run a image,

```
docker run -d --name -p 999:22 tf <IMAGE>
```

Login container via ssh,

```
ssh -p 999 tf@localhost
```

> Password is **testpass**.
