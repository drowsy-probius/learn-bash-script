# 06-good-practices

---

`set` 키워드를 사용하여 유용한 동작을 수행할 수 있다. [manual set](https://linuxcommand.org/lc3_man_pages/seth.html)


`set -u`: 선언되지 않은 변수를 사용하면 에러를 발생한다.

`set -e`: 스크립트에서 어떤 명령줄이 실패하면 이후 명령어를 실행하지 않는다.

`set -x`: 실행된 명령어 스택을 출력한다.

```bash
#!/usr/bin/env bash

set -u

NEW_VAR=1
echo "$NEW_VAR"

echo "$UNBOUND_VAR"
# UNBOUND_VAR: unbound variable. exit 1
```

---

문자열 변수 값은 쌍따옴표 `"`로 감싸는게 좋다.

예를 들어 파일 명에 공백이 포함된 파일을 다룰 때 `"`로 이름을 감싸지 않으면 공백 이전 이후로 파일명이 분리되어 처리된다.

```bash
$ FILENAME="new file with space"
$ if [ $FILENAME = "new file with space" ];
then
  echo "True"
else
  echo "False"
fi

bash: [: too many arguments
False



$ if [ "$FILENAME" = "new file with space" ];
then
  echo "True"
else
  echo "False"
fi

True
```

> 참고: zsh에서는 `"`로 감싸지 않아도 의도한 대로 동작한다.

---

`trap`을 사용하여 스크립트 실행에 실패했을 때 수행할 동작을 지정할 수 있다. `try ... catch ...`와 유사하게 사용할 수 있다.

```bash
#!/usr/bin/env bash

set -ex

trap catch_function SIGINT SIGTERM ERR
trap exit_function EXIT

catch_function(){
  trap - SIGINT SIGTERM ERR
  echo "Exit by trap!!"
}

exit_function() {
  trap - EXIT
  echo "Exit!!"
}

ls -zzzz
```

```text
+ trap catch_function SIGINT SIGTERM ERR
+ trap exit_function EXIT
+ ls -zzzz
ls: invalid option -- 'z'
Try 'ls --help' for more information.
++ catch_function
++ trap - SIGINT SIGTERM ERR
++ echo 'Exit by trap!!'
Exit by trap!!
+ exit_function
+ trap - EXIT
+ echo 'Exit!!'
Exit!!
```

---

`lockfile` 또는 `pid` 파일을 작성하거나 하나의 파일에 여러 bash 프로세스가 작성하려고 할 때 의도치 않은 결과가 발생할 수 있다.

이미 존재하는 파일에 stdout를 통하여 새 내용을 덮어쓰기하여 데이터가 손실되는 경우를 `clobbering`이라 부른다.

bash에서는 `set -o noblobber`를 수행하여 덮어쓰기를 방지할 수 있다.

한 시점에 하나의 스크립트 파일만 실행되어야 하는 경우에 유용하게 사용할 수 있다.

```bash
# 현재 PID를 `lockfile`에 작성한다.
# 실패하여 stderr가 발생하면 `/dev/null`로 전달하여 표시하지 않고
# else 분기로 이동한다.
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; 
then
  # 스크립트가 의도치 않게 종료되더라도 생성된 `lockfile`를 삭제한다.
  trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

  critical-section

  rm -f "$lockfile"
  trap - INT TERM EXIT
else
  echo "Failed to acquire lockfile: $lockfile." 
  echo "Held by $(cat $lockfile)"
fi
```

---

여러 프로세스가 구동 중인 시스템에서 다른 프로세스에 접근 가능한 자원(예: 파일)을 수정하는 경우에는 atomic하게 작업을 수행하는 것이 좋다.

예를 들어 호스팅 중인 웹 파일 내의 도메인 이름을 한꺼번에 변경한다면 기존 폴더의 사본을 생성하고 사본 내의 파일을 수정 후 사본을 원본에 덮어씌우는 방식으로 수행할 수 있다.


```bash
# 파일과 폴더를 복사하되 권한과 같은 속성도 복사한다.
cp -a /var/www /var/www-tmp

# 사본 폴더의 내용을 수정한다.
for file in $(find /var/www-tmp -type f -name "*.html"); do
   perl -pi -e 's/www.example.net/www.example.com/' $file
done

# 원본 폴더의 이름을 변경하고
mv /var/www /var/www-old
# 사본 폴더의 내용으로 바꿔치기한다.
mv /var/www-tmp /var/www
```

---