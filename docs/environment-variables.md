# Environment variables

It is a list of all available `TROJAN_*` environment variables we supported, and its description and its location on the configuration file of `trojan` (default is `/config/config.json`).

| environment variables             | default   | location                      | description                                                                                                                                               |
|-----------------------------------|-----------|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ENVSUBST_ENABLED`                | false     | N/A                           | Whether to turn on.`envsubst`                                                                                                                             |
| `TROJAN_LOCALE_ADDR`              | 0.0.0.0   | `.local_addr`                 | trojan server will be bound to the specified interface. Feel free to change this to :: or other addresses, if you know what you are doing.                |
| `TROJAN_LOCALE_PORT`              | 443       | `.local_port`                 | trojan server will be bound to this port                                                                                                                  |
| `TROJAN_REMOTE_ADDR`              | 127.0.0.1 | `.remote_addr`                | the endpoint address that trojan server will connect to when encountering [other protocols][other-protocols]                                              |
| `TROJAN_REMOTE_PORT`              | 80        | `.remote_port`                | the endpoint port that trojan server will connect when encountering [other protocols][other-protocols]                                                    |
| `TROJAN_PASSWORD`                 | password1 password2 | `.password`         | an array of passwords used for verification[^1]                                                                                                           |
| `TROJAN_LOG_LEVEL`                | 1         | `.log_level`                  | how much log to dump. 0: ALL; 1: INFO; 2: WARN; 3: ERROR; 4: FATAL; 5: OFF.                                                                               |
| `TROJAN_SSL_CERT`                 | /config/ssl/certificate.crt | `.ssl.cert` | server certificate **STRONGLY RECOMMENDED TO BE SIGNED BY A CA.** It’s preferred to use the full chain certificate here instead of the certificate alone. |
| `TROJAN_SSL_KEY`                  | /config/ssl/private.key | `.ssl.key`      | private key file for encryption                                                                                                                           |
| `TROJAN_SSL_KEY_PASSWORD`         |           | `.ssl.key_password`           | password of the private key file                                                                                                                          |
| `TROJAN_SSL_CIPHER`               | see [here][trojan_ssl_cipher][^2] | `.ssl.cipher` | a cipher list to use                                                                                                                              |
| `TROJAN_SSL_CIPHER_TLS13`         | see [here][trojan_ssl_cipher_tls13][^2] | `.ssl.cipher_tls13` | a cipher list for TLS 1.3 to use                                                                                                      |
| `TROJAN_SSL_PREFER_SERVER_CIPHER` | true      | `.ssl.prefer_server_cipher`   | whether to prefer server cipher list in a connection                                                                                                      |
| `TROJAN_SSL_ALPN`                 | http/1.1  | `.ssl.alpn`                   | a list of `ALPN` protocols to reply [^1]                                                                                                                  |
| `TROJAN_SSL_ALPN_PORT_OVERRIDE_H2` | 81       | `.ssl.alpn_port_override.h2`  | overrides the remote port to the specified value if an `ALPN` is matched. Useful for running NGINX with HTTP/1.1 and HTTP/2 Cleartext on different ports. |
| `TROJAN_SSL_REUSE_SESSION`        | true      | `.ssl.reuse_session`          | whether to reuse `SSL` session                                                                                                                            |
| `TROJAN_SSL_SESSION_TICKET`       | false     | `.ssl.session_ticket`         | whether to use session tickets for session resumption                                                                                                     |
| `TROJAN_SSL_SESSION_TIMEOUT`      | 600       | `.ssl.session_timeout`        | if `reuse_session` is set to true, specify `SSL` session timeout                                                                                          |
| `TROJAN_SSL_PLAIN_HTTP_RESPONSE`  |           | `.ssl.plain_http_response`    | respond to plain http request with this file (raw TCP)                                                                                                    |
| `TROJAN_SSL_CURVES`               |           | `.ssl.curves`                 | `ECC` curves to use                                                                                                                                       |
| `TROJAN_SSL_DHPARAM`              |           | `.ssl.dhparam`                | if left blank, default (RFC 3526) dhparam will be used, otherwise the specified dhparam file will be used                                                 |
| `TROJAN_TCP_PREFER_IPV4`          | false     | `.tcp.prefer_ipv4`            | whether to connect to the IPv4 address when there are both IPv6 and IPv4 addresses for a domain                                                           |
| `TROJAN_TCP_NO_DELAY`             | true      | `.tcp.no_delay`               | whether to disable Nagle’s algorithm                                                                                                                      |
| `TROJAN_TCP_KEEP_ALIVE`           | true      | `.tcp.keep_alive`             | whether to enable TCP Keep Alive                                                                                                                          |
| `TROJAN_TCP_REUSE_PORT`           | false     | `.tcp.reuse_port`             | whether to enable TCP port reuse (kernel support required)                                                                                                |
| `TROJAN_TCP_FAST_OPEN`            | false     | `.tcp.fast_open`              | whether to enable TCP Fast Open (kernel support required)                                                                                                 |
| `TROJAN_TCP_FAST_OPEN_QLEN`       | 20        | `.tcp.fast_open_qlen`         | the server’s limit on the size of the queue of TFO requests that have not yet completed the three-way handshake                                           |
| `TROJAN_MYSQL_ENABLED`            | false     | `.mysql.enabled`              | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_SERVER_ADDR`        | 127.0.0.1 | `.mysql.server_addr`          | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_SERVER_PORT`        | 3306      | `.mysql.server_port`          | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_DATABASE`           | trojan    | `.mysql.database`             | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_USERNAME`           | trojan    | `.mysql.username`             | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_PASSWORD`           |           | `.mysql.password`             | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_KEY`                |           | `.mysql.key`                  | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_CERT`               |           | `.mysql.cert`                 | see [Authenticator]                                                                                                                                       |
| `TROJAN_MYSQL_CA`                 |           | `.mysql.ca`                   | see [Authenticator]                                                                                                                                       |

## TROJAN_SSL_CIPHER

The default `TROJAN_SSL_CIPHER` value is

```txt
TROJAN_SSL_CIPHER:-ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
```

## TROJAN_SSL_CIPHER_TLS13

The default `TROJAN_SSL_CIPHER_TLS13` value is

```txt
TROJAN_SSL_CIPHER_TLS13:-TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384
```

## Reference

<https://trojan-gfw.github.io/trojan/config#a-valid-serverjson>

<!-- footnote -->

[^1]: The array / list here is separated through spaces.
[^2]: It's too long to display.

<!-- links -->

[other-protocols]: https://trojan-gfw.github.io/trojan/protocol#other-protocols
[Authenticator]: https://trojan-gfw.github.io/trojan/authenticator
[trojan_ssl_cipher]: #trojan_ssl_cipher
[trojan_ssl_cipher_tls13]: #trojan_ssl_cipher_tls13
