# 00-template

A는 매사가 귀찮은 사람이라 다운로드 폴더를 정리하지 않는다. 어느날 A가 컴퓨터 용량을 확인해보니 다운로드 폴더가 디스크의 용량의 대부분을 차지하고 있었다. 

마지막으로 사용한지 (access) 7일이 지난 파일만 삭제하는 스크립트를 작성하여 다운로드 폴더를 정리하고자 한다.

문제 환경 구성을 위하여 `init-example.sh`를 한번 실행한다.

## 결과
```bash
$ ./main.sh
Remove: './downloads/birthday_file'
Remove: './downloads/newyear_file (1)'
Remove: './downloads/newyear_file'
Remove: './downloads/newyear_file (2)'
Remove: './downloads/vacation ends'
Remove: './downloads/101010_file'
```


## 참고
```bash
$ find -help
# Truncated
#
# find의 `-exec`옵션은 명령어 끝에 
# `\;`를 붙어야한다.
```

