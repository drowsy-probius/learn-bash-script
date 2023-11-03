# 18-functions

프로그램 자동 설치 스크립트를 작성하면서 어느 명령에서 에러가 발생하는지 디버깅을 하려고 한다.

각 명령어 이후에 실행할 함수 `exit_if_error`를 작성하여 디버깅을 수행한다.

`exit_if_error`함수는 다음과 같은 일을 수행한다.

```
1. 인자로 문자열을 받는다. 
2. 이전 명령어의 종료 코드가 0이 아니라면 인자 문자열을 출력한뒤 스크립트를 종료한다.
```

`exit_if_error`함수를 작성하시오.

## 결과
```bash
$ ./main.sh
Start Of Script
total 20K
drwxr-xr-x  2 abc abc 4.0K Nov  4 00:59 .
# TRUNCATED
ls: invalid option -- 'j'
Try 'ls --help' for more information.

ERROR!!!!
list directory with unknown flags
```
