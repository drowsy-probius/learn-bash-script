# 진입점1 - init.sh

첫번째 진입점 `init.sh` 파일에 대한 설명

## 파일 개요
```bash
sample
│ # 첫번째 진입점 파일
├── init.sh
├── switch.sh
├── launch_functions.sh
├── map_nic_and_container.sh
├── monitor.sh
└── shutdown.sh
```

## `init.sh`

```bash
## /usr/bin/bash 가 아니라 /usr/bin/env를 참조하여
## 시스템에 여러 버전의 bash가 있는 경우에도
## 현재 사용자가 사용 중인 버전의 bash를 사용할 수 있도록 설정함 
#!/usr/bin/env bash

# `$0`은 실행 파일을 나타낸다.
# 스크립트가 존재하는 폴더의 절대 경로를 변수에 할당한다.
SRC_DIR=$(cd "$(dirname $0)" && pwd)

# 스크립트가 존재하는 폴더로 이동한다.
cd $SRC_DIR

# 공통 함수를 임포트한다
source launch_functions.sh

# `api`라는 도커 네트워크를 생성한다.
silent_try docker network create api

# 도커 이미지 이름은 `wep_api`, 태그는 현재 시간을 초 단위로 나타낸 것으로 설정한다
IMAGE_TAG=wep_api:$(date +%s)

# `-q` 옵션으로 생성된 도커 이미지의 ID를 출력하도록 지정한다. 그렇지만 slient 함수를 사용해서 터미널에 출력되지는 않는다.
# `-t` 옵션으로 생성할 이미지 태그를 지정한다
# Dockerfile이 위치한 디렉토리를 지정한다.
silent docker build -qt $IMAGE_TAG ./image

# nginx에서 참조하는 파일을 지운 후
rm -f ./conf.d/upstream/web-api.conf
# `web-api-blue`에 해당하는 설정 파일을 soft link로 생성한다.
ln -s ../upstream-blue/web-api.conf ./conf.d/upstream/web-api.conf

# NAME=web-api; TYPE=blue; IMAGE=wep_api:123456789;
# HEALTH_PATH=:3000; CONTAINER_NAME=wep_api:123456789-blue
# 위와 같은 설정으로 컨테이너를 실행한다.
# HEALTH_PATH가 지정되었으니 `http_health_check`를 수행한다.
launch_app web-api blue "${IMAGE_TAG}" ":3000"

# nginx가 구동중인 `api-gateway` 컨테이너를 삭제한다.
silent_try docker rm -f api-gateway
# nginx 설정 파일이 위치한 디렉토리를 바인딩하고
# 80포트를 바인딩하여 nginx 컨테이너를 실행한다.
silent docker run -d --name api-gateway \
	--restart=always \
	-p 80:80 \
	--network api \
	-v $(pwd)/conf.d:/etc/nginx/conf.d \
	nginx
```