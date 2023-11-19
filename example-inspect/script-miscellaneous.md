# 기타 스크립트 파일 

`lanuch_functions.sh`, `map_nic_and_container.sh`, `monitor.sh`, `shutdown.sh` 파일에 대한 설명

## 파일 개요
```bash
sample
├── init.sh
├── switch.sh
│
│ # 공용 함수 선언
├── launch_functions.sh
│ # 컨테이너가 사용하는 브릿지 네트워크 인터페이스 목록 출력
├── map_nic_and_container.sh
│ # 현재 실행중인 모든 컨테이너의 목록 출력
├── monitor.sh
│ # web-api에 해당되는 컨테이너 강제종료 및 삭제
└── shutdown.sh
```



## `map_nic_and_container.sh`

실행 중인 컨테이너에 연결된 네트워크 인터페이스가 호스트의 어떤 네트워크 인터페이스인지 보여준다.

shebang (`#!`)으로 시작하는 것으로 보아 단독으로 실행하도록 의도된 파일이다.

```bash
#!/usr/bin/env bash

# 실행중인 컨테이너의 이름을 배열로 선언한다
CONTAINERS=$(docker ps --format '{{ printf "%s" .Names }}')

# 모든 컨테이너에 대해서 아래 작업을 수행한다
for I in $CONTAINERS; do
# 컨테이너 이름을 출력한다
echo $I

# 컨테이너 내에 root 유저로 명령어를 수행하고 리턴한다
# `eth0`으로 지정된 네트워크 인터페이스의 커널 식별자를 가져온다.
# `eth0`은 일반적으로 기본 이더넷 인터페이스이다.
ID=$(docker exec -i --user 0 $I cat /sys/class/net/eth0/iflink)

# 호스트에 연결된 네트워크 인터페이스 중에서 해당되는 인터페이스를 출력한다.
ip ad | grep ${ID}

done
```


## `monitor.sh`

현재 실행 중인 컨테이너 목록을 이름, 상태, 이미지로 알려준다.

shebang (`#!`)으로 시작하는 것으로 보아 단독으로 실행하도록 의도된 파일이다.

```bash
#!/usr/bin/env bash

# 아래 명령어를 계속 수행한다
while true; do
  # 현재 실행중인 컨테이너 목록을 이름, 상태, 이미지의 리스트로 가져온다
  CON=$(docker ps --format '{{ printf "%-40.50s" .Names}} {{ printf "%-30.50s" .Status}} {{.Image}}' | sort);
  # 터미널의 출력을 모두 지운다
  clear;
  # 컨테이너 목록을 출력한다.
  echo "$CON";
  # 0.1초 대기한다
  sleep .1;
done
```

## `shutdown.sh`

`web-api`로 동작하도록 실행된 컨테이너를 모두 삭제한다.

shebang (`#!`)으로 시작하는 것으로 보아 단독으로 실행하도록 의도된 파일이다.

```bash
#!/usr/bin/env bash

docker ps | grep -E '(blue|green)' | awk '{print $1}' | xargs docker rm -f
```


## `lanuch_functions.sh`

공용 함수가 정의되어 있다.

```bash

# ANSI color 포맷의 색상 변수를 선언한다.
setup_colors() {
  # [[ -t 2 ]] 
  # 현재 쉘에서 stderr로 출력할 수 있고
  # [[ -z "${NO_COLOR-}" ]]
  # NO_COLOR 변수가 설정되어 있지 않고 (터미널이 ANSI color을 지원하고)
  # [[ "${TERM-}" != "dumb" ]]
  # 현재 터미널 유형이 `dumb`가 아닌 경우면
  # ANSI color 포맷 문자열을 지정한다.
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}
```

```bash
# 주어진 인자를 stderr 스트림으로 출력한다.
# 주로 CLI 앱에서 stdout은 앱의 결과물을, stderr는 앱의 로그를 출력할 때 사용한다.
# `-e` 옵션을 사용하여 `\n`등의 이스케이프 문자열도 사용 가능하도록 한다.
msg() {
  echo >&2 -e "${1-}"
}
```

```bash
# 인자로 받은 주소에 대해서 http 으로 접근 가능한지 검사한다
function http_health_check() {
  ENDPOINT=$1

  # 최대 12번 동안 다음을 수행한다.
  for attempt in $(seq 12); do
    # curl 도커 이미지를 사용하여 
    # web-api와 같은 네트워크에 컨테이터를 만들어
    # 주어진 주소에 접근 가능한지 확인한다.
    #
    # curl `-X GET`으로 GET요청을 전송
    # `-s`, `-o /dev/null` 으로 출력 없이, 데이터는 저장하지 않도록 설정
    # `-w %{http_code}` 으로 http 상태 코드만 출력하도록 설정
    # `|| echo 0`으로 curl 명령이 실패한 경우 기본 값으로 0을 설정 
    RES_CODE=$(docker run --rm --network api \
      curlimages/curl -X GET -so /dev/null -w '%{http_code}' "$ENDPOINT" || echo 0)
    
    # 상태 값이 200이면
    if [[ '200' -eq "$RES_CODE" ]]; then
      # 녹색으로 로그 출력 후 함수 종료
      msg "${GREEN}${ENDPOINT} is up${NOFORMAT}"
      return 0
    fi
    # 실패하면 5초간 기다린다.
    sleep 5
  done

  # 12번의 시도가 모두 실패하면 프로그램을 exit code 1으로 종료한다.
  msg "${RED}Failed to check desired app $ENDPOINT for 1min !!!${NOFORMAT}"
  exit 1
}
```

```bash
# stdout을 출력하지 않고 인자로 넘긴 명령어를 실행한다.
function silent() {
  "$@" >/dev/null
}
```

```bash
# stdout, stderr를 출력하지 않고 인자로 넘긴 명령어를 실행한다.
# 명령이 실패하더라도 기본 값으로 빈 문자열을 출력하여 안전하게 수행한다.
function silent_try() {
  "$@" >/dev/null 2>/dev/null || printf ''
}

```

```bash
# web-api 도커 컨테이너를 실행하는 명령을 감싼 함수이다.
function launch_app() {
  # 함수 내부에서 인자를 받은 후 global하게 선언한다.
  export NAME=$1
  export TYPE=$2
  export IMAGE=$3
  export HEALTH_PATH=$4

  export CONTAINER_NAME="$NAME-$TYPE"

  msg "${YELLOW}Launching $CONTAINER_NAME ...${NOFORMAT}"

  
  # 최대 5번 동안 수행한다.
  for i in $(seq 1 5); do
    # 이미 컨테이너가 존재하면 강제로 삭제한다.
    silent_try docker rm -f "$CONTAINER_NAME"
    
    # 도커 네트워크 `api`를 사용하도록 지정하여
    # 컨테이너를 실행한다.
    # 성공하면 반복문을 나가고 실패하면 에러 메시지 출력 후 5초 대기한다.
    # shellcheck disable=SC2086
    silent docker run -d --restart always \
      --name "$CONTAINER_NAME" \
      --network api \
      "$IMAGE" && break || (echo retry lauch $CONTAINER_NAME ...; sleep 5)
  done

  # health check 경로가 인자로 주어지면
  if [ -n "$HEALTH_PATH" ]; then
    msg "Checking health for $CONTAINER_NAME"
    # 방금 실행한 컨테이너에 대해서 health check를 수행한다.
    http_health_check "http://${CONTAINER_NAME}${HEALTH_PATH}"
  else
    msg "Skipping health check for $CONTAINER_NAME"
  fi
}
```

```bash
# 외부에서 임포트 할 수 있도록 함수를 내보낸다.
export -f launch_app
export -f silent
export -f silent_try
export -f setup_colors
export -f msg
```





# Appendix

## `:-`와 `-`의 차이

변수를 사용하면서 그 변수의 기본 값을 설정할 때 `"${NOT_VAR-2}"` 혹은 `"${NOT_VAR:-2}"`를 사용하기도 한다. 

두개의 차이점은 아래와 같다.

```bash
$ NOT_VAR=""
$ echo "$NOT_VAR"
 # 빈 문자열
$ echo "${NOT_VAR-2}"
 # 빈 문자열
$ echo "${NOT_VAR:-2}"
2
$
```

`:-`는 변수가 설정되어있지 않거나 빈 값으로 설정되어 있으면 기본 값을 설정하고 `-`는 변수가 설정되어있지 않을 때에만 기본 값을 설정한다.


# References

https://betterdev.blog/minimal-safe-bash-script-template/

https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46

