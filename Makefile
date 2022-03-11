CUDA_IMAGE   := ubuntu:18.04-cuda
GPU_IMAGE := ubuntu:18.04-ai-gpu
CPU_IMAGE := ubuntu:18.04-ai-cpu

include cuda.mk

ifdef AUTO_VIM
	AUTO_VIM_ := $(AUTO_VIM)
else
	AUTO_VIM_ := ""
endif

ifdef CHINA
	CHINA_ := $(CHINA)
else
	CHINA_ := ""
endif

all: build-cuda-image build-ai-gpu

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

.PHONY: build-ai-gpu
build-ai-gpu:
	docker build \
	  -f docker/Dockerfile.gpu \
	  -t $(GPU_IMAGE) \
	  --build-arg BASE_IMG=$(CUDA_IMAGE) \
	  --build-arg AUTO_VIM=$(AUTO_VIM_) \
	  --build-arg CHINA=$(CHINA_) \
	  .

.PHONY: build-ai-cpu
build-ai-cpu:
	docker build \
	  -f docker/Dockerfile.cpu \
	  -t $(CPU_IMAGE) \
	  --build-arg AUTO_VIM=$(AUTO_VIM_) \
	  --build-arg CHINA=$(CHINA_) \
	  .

.PHONY: clean
	rm -f cuda_*.run
