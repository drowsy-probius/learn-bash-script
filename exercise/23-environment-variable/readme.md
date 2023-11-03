# 23-environment-variable

현재 쉘과 자식 쉘에 적용되는 변수(환경변수)를 선언합니다. 

수행해야 하는 작업은 다음과 같습니다.

1. `main.sh` 파일에 변수 `YOUR_VARIABLE`를 값 `HELLO!`으로 `export`키워드를 사용하여 선언합니다.
2. `main.sh` 파일을 실행합니다.
3. `echo $YOUR_VARIABLE`를 수행해봅니다.

## 결과
```bash
$ source ./main.sh
$ echo $YOUR_VARIABLE
HELLO!
$ unset YOUR_VARIABLE
$ echo $YOUR_VARIABLE

```


# 참고

http://linuxcommand.org/lc3_man_pages/exporth.html

```bash
$ cat ~/.bashrc
```

```bash
$ set
# 현재 설정된 지역변수와 환경변수 목록
# Truncated

$ env
# 현재 설정된 환경변수 목록
# Truncated
```
