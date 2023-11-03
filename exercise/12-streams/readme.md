# 12-streams

character stream에 대해 다룹니다.

`main.sh` 스크립트의 실행 결과에 대해서 standard input은 `stdout.txt`으로, standard error는 `stderr.txt`으로 출력 내용을 저장합니다.

## 결과
```bash
$ {YOUR_ANSWER_HERE}
$ cat ./stdout.txt
total 24K
drwxr-xr-x  2 abc abc 4.0K Nov  4 00:25 .
drwxr-xr-x 15 abc abc 4.0K Nov  4 00:21 ..
-rw-r--r--  1 abc abc   63 Nov  4 00:24 answer.sh
-rw-r--r--  1 abc abc   56 Nov  4 00:21 main.sh
-rw-r--r--  1 abc abc  254 Nov  4 00:23 readme.md
Done!

$ cat ./stderr.txt
+ ls -alh
+ not_exists_command
bash.sh: line 7: not_exists_command: command not found
+ echo 'Done!'

```
