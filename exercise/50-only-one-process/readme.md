# 50-only-one-process

춘식이는 L사에서 데이터 엔지니어로 근무 중이다.

매 시간마다 데이터 소스로부터 데이터를 가져와서 정제하는 로직을 작성하라는 업무를 할당받았다.

춘식이는 `cron`설정으로 bash 쉘에서 `main.sh`파일을 정각마다 실행하도록 설정하였다. 

그러나 이전 시간까지 쌓인 데이터 소스가 적을 때에는 `main.sh`을 수행하는 프로세스가 1시간 이내로 종료했지만 특정 시간대(예: 03시)에는 데이터가 많아 프로세스가 1시간 이상 동작하여 그 다음 시각(예: 04시)에 동작하는 프로세스에 영향을 주는 것을 관찰하였다.

그래서 춘식이는 `main.sh` 파일 상단에 현재 `main.sh`파일이 실행 중이라면 새로운 프로세스가 생성되지 않도록 `exit`하는 로직을 작성하고자 한다.

## 파일 설명

- `main.sh`

메인 로직이 실행되는 스크립트 파일. 문제에서는 프로세스가 `interrupt` 이외에는 정지되지 않도록 설정하였다.

위 파일 상단에 `main.sh`가 실행 중인지 검사하는 로직을 추가해야한다.

## 결과

쉘을 2개 띄워서 각각 실행하여야 한다.

### bash shell 1
```bash
$ ./main.sh
Currently Running...
# and runs forever
```

### bash shell 2
```bash
$ ./main.sh
There is no place for me...
# and exits with code 1
```



## 참고

```bash
$ echo "$0"
/usr/bin/bash
```

```bash
$ pidof -help
pidof usage: [options] <program-name>

 -c           Return PIDs with the same root directory
 -d <sep>     Use the provided character as output separator
 -h           Display this help text
 -n           Avoid using stat system function on network shares
 -o <pid>     Omit results with a given PID
 -q           Quiet mode. Do not display output
 -s           Only return one PID
 -x           Return PIDs of shells running scripts with a matching name
 -z           List zombie and I/O waiting processes. May cause pidof to hang.
```

```text
from https://man7.org/linux/man-pages/man1/pidof.1.html

-o omitpid
  Tells pidof to omit processes with that process id. The
  special pid %PPID can be used to name the parent process
  of the pidof program, in other words the calling shell or
  shell script.
```

```bash
$ pgrep -h
# Truncated. goto https://linux.die.net/man/1/pgrep
$ echo "$$"
116989 # Result changes on your system
```

```bash
$ echo "$PPID" # parent process id of current process
5580 # Result changes on your system
```

```bash
$ ps --help
# Truncated
$ ps -ef
# Truncated
```