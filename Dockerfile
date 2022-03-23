FROM alpine:3.15.2 as trojan_builder

RUN apk add --no-cache --virtual .build-deps \
        boost-build boost-dev build-base clang-dev cmake ninja \
        mariadb-connector-c-dev openssl-dev git

WORKDIR /workspace

ARG TROJAN_VERSION
ARG TROJAN_GIT=https://github.com/trojan-gfw/trojan.git
RUN git clone --depth 1 --recurse-submodules -b ${TROJAN_VERSION} ${TROJAN_GIT} .
RUN cmake . -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_INSTALL_PREFIX=/workspace/pkg \
        -DDEFAULT_CONFIG=/config/config.json \
        -DFORCE_TCP_FASTOPEN=ON \
        -G Ninja \
    && ninja -j$(nproc) \
    && ninja install

FROM alpine:3.15.2 as ssl_maker

RUN apk add --no-cache openssl

WORKDIR /workspace

# WARNING: ONLY FOR DEVELOPMENT
# You should prepare your OWN *.key and *.crt files
RUN openssl req  -nodes -new -x509 -days 3650 \
        -keyout private.key -out certificate.crt \
        -subj "/C=CN/ST=Beijing/L=Beijing/O=Trojan-Gfw/OU=Trojan-Gfw/CN=Trojan-Gfw"

FROM alpine:3.15.2 as gettext

RUN apk add --no-cache gettext

FROM alpine:3.15.2

RUN apk add --no-cache --virtual .trojan-rundeps \
        libstdc++ boost-system boost-program_options mariadb-connector-c \
    && apk add --no-cache --virtual .envsubst-rundeps libintl

COPY --from=trojan_builder /workspace/pkg /usr
COPY --from=ssl_maker /workspace /config/ssl
COPY --from=gettext /usr/bin/envsubst /usr/bin/envsubst
ADD --chown=1000:100 root /

ENV ENVSUBST_ENABLED=false \
    TROJAN_SSL_CERT=/config/ssl/certificate.crt \
    TROJAN_SSL_KEY=/config/ssl/private.key

# Test the trojan
RUN test -f /usr/bin/trojan \
    && /usr/bin/trojan --version \
    && tmpfile=$(mktemp) \
    && ENVSUBST_ENABLED=true TROJAN_CONFIG=${tmpfile} \
        /run.sh --test ${tmpfile} \
    && /run.sh --test /config/config.json

EXPOSE 80 80/udp 443 443/udp

VOLUME [ "/config", "/config/ssl" ]

ENTRYPOINT [ "/run.sh" ]

CMD [ "--config", "/config/config.json" ]
