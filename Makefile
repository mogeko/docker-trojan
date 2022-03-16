VERSION  = $(shell jq -r '.version' ./latest.json)

CMD      = /usr/bin/docker
IMAGE    = mogeko/trojan

.PHONY: all build run test help

all: build run

build:
	@$(CMD) build . \
	--build-arg TROJAN_VERSION=$(VERSION) \
	--tag $(IMAGE)

run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run:
	@-$(CMD) run -it --name trojan-$(id) $(IMAGE)
	@$(CMD) rm -f trojan-$(id)

test: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
test:
	@-$(CMD) run -d --name trojan-$(id) $(IMAGE)
	@$(CMD) rm -f trojan-$(id)

help: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
help:
	@-$(CMD) run -it --name trojan-$(id) $(IMAGE) --help
	@$(CMD) rm -f trojan-$(id)
