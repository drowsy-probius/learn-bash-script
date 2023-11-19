# nginx 설정 파일

## 파일 개요
```bash
sample/conf.d
├── common
│   ├── common.conf
│   └── proxy.conf
| # nginx 첫 진입점
├── default.conf
├── server
|   | # nginx가 처리하는 서버 설정
│   └── localhost.conf
├── upstream
|   | # 리버스 프록시 대상 서버 설정
│   └── web-api.conf -> ../upstream-green/web-api.conf
├── upstream-blue
│   └── web-api.conf
└── upstream-green
    └── web-api.conf
```

## `default.conf`

nginx 첫 진입점. 하위 `server`, `upstream` 폴더에 라우팅을 맡긴 것이라 생각해도 됨.

```conf
include /etc/nginx/conf.d/upstream/*.conf;
include /etc/nginx/conf.d/server/*.conf;
```

## `upstream/web-api.conf`

리버스 프록시 대상 서버를 지정하는 설정 파일

첫 설정은 soft link로 `upstream-green`을 가리키고 있음.

nginx 앱 내에서 `web-api` 서버는 `web-api-green:3000`을 가리키도록 설정됨.

```conf
# reverse proxy configuration
upstream web-api {
    server web-api-green:3000;
}
```


## `server/localhost.conf`

이 앱의 http 요청을 실제 처리하는 내용을 담은 설정 파일

```conf
server {
  # 80 포트에서 실행
  listen 80;

  # 도메인 이름은 `localhost`으로 설정
  server_name localhost;

  # 공통 설정 파일 임포트
  include /etc/nginx/conf.d/common/common.conf;

  # 포트 80 + 도메인 루트 요청에 대해서
  location / {
    # web-api 도메인 주소로 리버스 프록시 수행
    proxy_pass http://web-api/;
    # 리버스 프록시 설정 파일 임포트
    include /etc/nginx/conf.d/common/proxy.conf;
  }
}
```


## `common/common.conf`

```conf
# Enable HSTS
add_header Strict-Transport-Security "max-age=31536000" always;

# Optimize session cache
ssl_session_cache   shared:SSL:40m;
ssl_session_timeout 4h;

# Enable session tickets
ssl_session_tickets on;

client_max_body_size 30m;

# gzip
gzip on;
gzip_proxied any;
gzip_vary on;
```

## `common/proxy.conf`
```
proxy_redirect     off;
proxy_http_version 1.1;

proxy_set_header   Host $host;
proxy_set_header   X-Real-IP $remote_addr;
proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header   X-Forwarded-Host $server_name;
proxy_set_header   Upgrade $http_upgrade;
proxy_set_header   Connection 'upgrade';

proxy_cache_bypass $http_upgrade;
```