API_STATUS_META = https://mogeko.github.io/docker-trojan/
TROJAN_VERSION  = $(shell curl -s "${API_STATUS_META}" | jq -r '.trojan_ver')

CMD      = docker
IMAGE    = mogeko/trojan

.PHONY: all build run test help

all: build run

build:
	@$(CMD) build . \
	--build-arg TROJAN_VERSION=$(TROJAN_VERSION) \
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
