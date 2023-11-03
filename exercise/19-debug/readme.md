# 19-debug

`18-functions`문제에서 디버깅을 위하여 함수를 선언하였다. 

하지만 bash에는 `set` 키워드를 사용하여 간편하게 위와 유사한 동작을 수행할 수 있다.


## 결과
```bash
$ ./main.sh
+ echo 'Start Of Script'
Start Of Script
+ ls -alh .
total 20K
drwxr-xr-x  2 abc abc 4.0K Nov  4 01:05 .
# Truncated
+ ls -asdfjkxzncvjwaef
ls: invalid option -- 'j'
Try 'ls --help' for more information.
```
