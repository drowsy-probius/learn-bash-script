# 16-loop-over-fs

`scripts`폴더를 `depth=1`로 순회하여 발견한 `.sh` 스크립트 파일에 대해서 실행 권한을 주고 해당 스크립트를 순차적으로 실행한다.

## 결과
```bash
$ ./main.sh
Script No.1
Script No.2
The Last Script
```


# 참고
```bash
$ ./scripts/01.sh
bash: permission denied: ./scripts/01.sh

$ chmod +x ./scripts/01.sh
$ ./scripts/01.sh
Script No.1
```

```bash
$ ls ./scripts
01.sh  01.trash  02.sh  99.sh

$ ls ./scripts/*.sh
./scripts/01.sh  ./scripts/02.sh  ./scripts/99.sh
```