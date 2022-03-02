CUDA_IMAGE   := ubuntu:18.04-cuda
TF_GPU_IMAGE := ubuntu:18.04-tf-gpu

include cuda.mk

ifdef AUTO_VIM
	AUTO_VIM_ := $(AUTO_VIM)
else
	AUTO_VIM_ := ""
endif

all: build-tf-gpu

.PHONY: build-cuda-image
ifdef DOWNLOAD_CUDA
build-cuda-image: download-cuda-installer install-toolkit install-driver
else
build-cuda-image: install-toolkit install-driver
endif

.PHONY: download-cuda-installer
download-cuda-installer:
	wget $(CUDA_LINK)

.PHONY: install-toolkit
install-toolkit:
	docker build \
	  -f docker/Dockerfile.cuda \
	  -t $(CUDA_IMAGE)-toolkit \
	  --build-arg CUDA_INSTALLER=cuda_10.2.89_440.33.01_linux.run \
	  --build-arg http_proxy=http://192.168.100.200:3128 \
	  --build-arg https_proxy=http://192.168.100.200:3128 \
	  .

.PHONY: install-driver
install-driver:
	docker run \
		--name cuda-container-tmp_ \
		-v /usr/src:/usr/src \
		-v /lib/modules:/lib/modules \
		--privileged \
		$(CUDA_IMAGE)-toolkit \
		bash -c "bash /opt/cuda*.run --silent --driver && rm -f /opt/cuda*.run"
	docker commit cuda-container-tmp_ $(CUDA_IMAGE)
	docker rm -f cuda-container-tmp_

.PHONY: build-tf-gpu
build-tf-gpu: build-cuda-image
	docker build \
	  -f docker/Dockerfile \
	  -t $(TF_GPU_IMAGE) \
	  --build-arg BASE_IMG=$(CUDA_IMAGE) \
	  --build-arg AUTO_VIM=$(AUTO_VIM_) \
	  .

.PHONY: clean
	rm -f cuda_*.run
