# 00-template

pipe에 대해 실습합니다.

`data.txt` 파일을 읽은 후 `23`이 포함된 행만 출력합니다.

## 결과
```bash
$ pwd
/your/workspace/learn-bash-script/exercise/13-pipe
$ ./main.sh

```


## 참고
```bash
$ cat data.txt
total 64K
drwxr-xr-x 16 abc abc 4.0K Nov  4 00:30 .
drwxr-xr-x  4 abc abc 4.0K Nov  3 23:00 ..
drwxr-xr-x  2 abc abc 4.0K Nov  3 23:21 00-template
drwxr-xr-x  2 abc abc 4.0K Nov  3 23:11 01-execute
# Truncated
```

```bash
$ echo "123\n456"  
123
456
$ echo "123\n456" | grep 1
123
```