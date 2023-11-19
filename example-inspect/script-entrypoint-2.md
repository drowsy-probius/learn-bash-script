# 진입점2 - switch.sh

첫번째 진입점 `switch.sh` 파일에 대한 설명

## 파일 개요
```bash
sample
├── init.sh
│ # 두번째 진입점 파일
├── switch.sh
├── launch_functions.sh
├── map_nic_and_container.sh
├── monitor.sh
└── shutdown.sh
```

## `switch.sh` 함수부
```bash
# `SIGINT` `SIGTERM` `ERR` 시그널이 발생하면 실행된다.
# 현재 쉘에서 실행한 작업이 있다면 TERM 시그널을 발생하여 종료시킨다.
cleanup() {
  ## 이전에 설정한 trap을 모두 초기화한다.
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  msg "${RED}Err !!! cleaning up ...${NOFORMAT}"
  if [[ ! 0 -eq $(jobs -p | wc -l) ]]; then
    # shellcheck disable=SC2046
    kill $(jobs -p)
  fi
}
```

```bash
# `EXIT` 시그널이 발생하면 실행된다.
# 현재 쉘에서 실행한 작업이 있다면 TERM 시그널을 발생하여 종료시킨다.
clean_exit() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  msg "cleaning up ..."
  if [[ ! 0 -eq $(jobs -p | wc -l) ]]; then
    # shellcheck disable=SC2046
    kill $(jobs -p)
  fi
}
```

```bash
# 실행 중인 bash의 버전을 검사하여 major 버전이 4보다 작다면 종료 코드 1을 리턴하고 종료한다.
# ${BASH_VERSION:0:1}은 $BASH_VERSION의 첫 글자만을 가져온다.
bash_version_check() {
  if [[ ${BASH_VERSION:0:1} -le 3 ]]; then
    msg "Bash 4+ required !!"
    exit 1
  fi
}
```

```bash
# 컨테이너에 종료 신호를 전달하고 삭제한다.
graceful_shutdown() {
  CONTAINER_NAME=$1

  # 컨테이너에 INTERRUPT으로 kill 명령어를 수행한 후
  silent_try docker kill -sINT "$CONTAINER_NAME"

  # 해당 컨테니어의 상태가 running이 아닐 때까지 기다린다.
  while [[ 1 -eq "$(docker ps --filter "Name=${CONTAINER_NAME}" --filter 'Status=running' -q | wc -l)" ]]; do
    sleep 1
  done

  # 컨테이너가 동작중이 아니게 되면 삭제한다.
  silent_try docker rm -f "$CONTAINER_NAME"
}
```

```bash
# 현재 구동 중인 `web-api`의 타입과 다른 타입의 컨테이너를 구동한다.
function switch() {
  NAME=$1
  IMAGE=$2
  HEALTH_PATH=$3

  # 설정 파일의 링크를 따라간 실제 절대 경로에 `blue`라는 문자열이 있다면
  if [ 1 -eq "$(readlink -f "./conf.d/upstream/${NAME}.conf" | grep -c blue)" ]; then
    # 새로 생성될 타입은 `green`으로 정한다.
    TO_BE=green
  else
    # 아니라면 `blue`으로 정한다.
    TO_BE=blue
  fi

  # 전환할 타입으로 컨테이너를 구동하고 health check를 수행한다.
  # 명령어 끝에 `&`을 붙임으로써 해당 작업은 백그라운드로 수행하도록 한다.
  launch_app "${NAME}" "${TO_BE}" "${IMAGE}" "${HEALTH_PATH}" &

  # 선언한 딕셔너리 변수에 앱 이름을 키로 하여 전환된 타입을 저장한다. 
  TARGET_VERSION[$NAME]=$TO_BE
}
```

```bash
# 변경한 타입에 맞게 nginx 설정을 변경하고 nginx 설정을 다시 로드한다 
function switch_nginx() {
  # 딕셔너리 변수에 있는 키와 값을 출력한다.
  msg '------------------------------------------'
  for key in "${!TARGET_VERSION[@]}"; do echo "$key => ${TARGET_VERSION[$key]}"; done
  msg '------------------------------------------'

  # shellcheck disable=SC2068
  for NAME in "${!TARGET_VERSION[@]}"; do
    # 변경될 타입을 변수로 할당한다.
    TO_BE=${TARGET_VERSION[$NAME]}
    # 업스트림 서버의 내용을 삭제한다.
    rm -f "conf.d/upstream/${NAME}.conf"
    # 변경될 타입과 관련된 설정 파일을 soft link로 생성한다.
    ln -s "../upstream-${TO_BE}/${NAME}.conf" "conf.d/upstream/${NAME}.conf"
  done

  # nginx의 설정이 유효한지 확인한다
  docker exec $GATEWAY_NAME nginx -t >/dev/null # must be success
  # nginx 엔진을 재시작한다
  docker exec $GATEWAY_NAME nginx -s reload     # new Workers will be created
}
```

```bash
# 이전 타입의 `web-api` 컨테이너를 삭제한다. 
function cleanup_container() {
  NAME=$1

  # 현재 upstream 파일의 이름을 통해서 이전 타입을 설정한다.
  if [ 1 -eq "$(readlink -f "./conf.d/upstream/${NAME}.conf" | grep -c blue)" ]; then
    PREV=green
  else
    PREV=blue
  fi

  CONTAINER_NAME="${NAME}-${PREV}"

  msg "${YELLOW}[-] Removing outdated ${CONTAINER_NAME}${NOFORMAT}"

  # 이전 타입의 컨테이너를 종료 후 삭제한다.
  graceful_shutdown "$CONTAINER_NAME"
}
```

## `switch.sh` 실행부

```bash
#!/usr/bin/env bash

SRC_DIR=$(cd "$(dirname $0)" && pwd)

cd $SRC_DIR

source launch_functions.sh

# TARGET_VERSION이라는 Associative array (딕셔너리, 맵, ...)을 선언한다
declare -A TARGET_VERSION
GATEWAY_NAME=api-gateway

# 명령어 에러 실행시에 스크립트를 즉시 종료하도록 설정
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
# `SIGINT`, `SIGTERM`, `ERR` 시그널 발생 시에 `cleanup` 함수를 수행한다. (파이썬의 except)
trap cleanup SIGINT SIGTERM ERR
# `EXIT` 시그널 발생시에 `clean_exit` 함수를 수행한다. (파이썬의 finally)
trap clean_exit EXIT

#####
# function declations...1
#####

# 터미널 색상 출력을 위한 변수 설정
setup_colors

#####
# function declations...2
#####

# 도커 이미지 태그 이름 선언
IMAGE_TAG=wep_api:$(date +%s)

# 도커 이미지 빌드 래핑 함수
function build_image() {
  silent docker build -qt $IMAGE_TAG ./image
}

# bash 버전을 검사하고 조건에 맞지 않으면 종료한다.
bash_version_check

msg "${GREEN}[*] Building new docker image${NOFORMAT}"
build_image

# web-api를 구동 중인 앱에 대해서
# 현재 앱이 green이면 blue를 아니면 그 반대의 값으로 컨테이너를 새로 생성한다
switch web-api \
  "$IMAGE_TAG" \
  ":3000/hello"

# 현재 쉘에서 구동한 프로그램이 모두 종료될 때까지 기다린다
# 이 경우에는 도커 컨테이너 생성이다.
for pid in $(jobs -p); do
  wait "$pid"
done

msg "${GREEN}[*] New containers are ready${NOFORMAT}"

msg "${GREEN}[*] Reload nginx config${NOFORMAT}"

# 새로 생성된 컨테이너의 유형에 맞게 nginx의 설정 파일을 변경후
# nginx가 구동중인 `api-gateway` 컨테이너에서 변경된 설정을 반영한다.
switch_nginx

msg "${YELLOW}Cleanup outdated containers ...${NOFORMAT}"
# `web-api`를 구동중인 컨테이너 중에서
# 현재 nginx와 연결되지 않은 컨테이너를 종료 후 삭제한다.
cleanup_container web-api
```



# References

https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/