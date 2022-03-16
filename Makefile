VERSION  = 1.16.0
CMD      = /usr/bin/docker
IMAGE    = mogeko/trojan

.PHONY: all build run help

all: build run

build:
	@$(CMD) build . \
	--build-arg TROJAN_VERSION=$(VERSION) \
	--tag $(IMAGE)

run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run:
	@-$(CMD) run -it --name trojan-$(id) $(IMAGE)
	@$(CMD) rm -f trojan-$(id)

help: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
help:
	@-$(CMD) run -it --name trojan-$(id) $(IMAGE) --help
	@$(CMD) rm -f trojan-$(id)