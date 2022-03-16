FROM alpine:3.14 as trojan_builder

RUN apk add --no-cache --virtual .build-deps \
        boost-build boost-dev build-base clang-dev cmake ninja \
        mariadb-connector-c-dev openssl-dev git

WORKDIR /workspace

ARG TROJAN_VERSION
ARG TROJAN_GIT=https://github.com/trojan-gfw/trojan.git
RUN git clone --depth 1 --recurse-submodules -b v${TROJAN_VERSION} ${TROJAN_GIT} .
RUN cmake . -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_INSTALL_PREFIX=/workspace/pkg \
        -DDEFAULT_CONFIG=/config/config.json \
        -G Ninja \
    && ninja -j$(nproc) \
    && ninja install

FROM alpine:3.14

RUN apk add --no-cache --virtual .trojan-rundeps \
        libstdc++ boost-system boost-program_options mariadb-connector-c

COPY --from=trojan_builder /workspace/pkg /usr
COPY --from=trojan_builder /workspace/pkg/etc/trojan /config

RUN test -f /usr/bin/trojan \
    && /usr/bin/trojan -v

VOLUME [ "/config" ]

ENTRYPOINT [ "/usr/bin/trojan" ]

CMD [ "--config", "/config/config.json" ]
