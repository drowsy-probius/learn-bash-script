# 14-if-file

파일이 존재하지 않으면 파일을 생성하고, 존재한다면 해당 파일에 현재 시간을 작성한다.

## 결과
```bash
$ ./main.sh
$ cat output.txt

$ ./main.sh
$ cat output.txt
Sat Nov 4 12:38:06 AM KST 2023
```


# 참고
```bash
$ ls
answer.sh  main.sh  readme.md
$ touch testfile.txt
$ ls
answer.sh  main.sh  readme.md testfile.txt
```