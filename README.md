# docker-trojan

[![ci_icon]][ci_link] [![image_size]][docker_link] [![image_ver]][docker_link]

Docker image for trojan. 

- Tiny size
- Keep updating

## Usage

Pull this image:

```shell
docker pull ghcr.io/mogeko/trojan
```

Run with docker cli:

```shell
docker run -d \
  --name trojan \
  -p 443:443 \
  -p 443:443/udp \
  -p 80:80 \
  -p 80:80/udp \
  -v /path/to/config:/config \
  -v /path/for/ssl/files:/config/ssl \
  --restart unless-stopped \
  ghcr.io/mogeko/trojan
```

Run with [docker-compose]:

```yml
---
version: 2.1
services:
  trojan:
    image: ghcr.io/mogeko/trojan
    container_name: trojan
    volumes:
      - /path/to/config:/config
      - /path/for/ssl/files:/config/ssl
    ports:
      - 443:443
      - 443:443/udp
      - 80:80
      - 80:80/udp
    restart: unless-stopped
```

## Parameters
<!-- TODO -->
The path of the default configuration file is `/config/config.json` (in container). You can configure it according to your needs. By the way, if you don't want to use the default configuration file path, you can overwrite it by a parameter transmitted to `trojan`:

```shell
docker run [do something] ghcr.io/mogeko/trojan -c /path/to/config (in container)
```

To ensure that the container can run normally in the default state, the container randomly generates a set of SSL `certificate.crt` and `private.key` when it compiles. **It works, BUT NOT SAFE!** So you should prepare a set of your **EXCLUSIVE** SSL `*.ctr` and `*.key`, and override `/config/ssl` (or other path). Finally, you need to make sure your SSL files match the path being set in configuration file (by default, it's `config/config.json`).

More help message about `trojan`, you can get via:

```shell
docker run -it ghcr.io/mogeko/trojan --help
```

## License

The code in this project is released under the [GPL-3.0 License][license].


<!-- badge -->

[ci_icon]: https://github.com/mogeko/docker-trojan/actions/workflows/auto-update.yml/badge.svg
[image_size]: https://img.shields.io/docker/image-size/mogeko/trojan/latest?logo=docker
[image_ver]: https://img.shields.io/docker/v/mogeko/trojan/latest?label=latest&logo=docker

<!-- links -->
[ci_link]: https://github.com/mogeko/docker-trojan/actions/workflows/auto-update.yml
[docker_link]: https://github.com/mogeko/docker-trojan/pkgs/container/trojan
[docker-compose]: https://docs.docker.com/compose
[license]: https://github.com/mogeko/docker-trojan/blob/master/LICENSE
