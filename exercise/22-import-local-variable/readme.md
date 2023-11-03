# 22-import=local-variable

현재쉘에서만 사용 가능한 변수(지역변수)를 다른 스크립트 파일로부터 불러옵니다.

수행해야 하는 작업은 다음과 같습니다.

1. `variables.sh` 파일에 변수 `YOUR_VARIABLE`를 값 `HELLO!`으로 선언합니다.
2. `main.sh`파일에서 `variables.sh` 스크립트를 불러옵니다.

## 결과
```bash
$ ./main.sh
HELLO!
```

# 참고

https://linuxcommand.org/lc3_man_pages/sourceh.html