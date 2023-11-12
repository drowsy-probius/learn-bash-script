# 03-stream-and-pipe

---

bash는 입출력를 `stdin`, `stdout`, `stderr` 3개로 구분한다. 각각 descriptor의 코드는 0, 1, 2로 할당되어있다. `>` 또는 `<` 등을 활용하여 각 입출력을 다른 입출력으로 전달하거나 파일에 작성할 수 있다.

`>`은 명령어의 출력을 전달하는 것이고 `<`은 명령어의 입력을 설정하는 것이다.

`stdin`, `stderr`의 내용을 `>`를 사용하여 각각 별도의 파일에 작성할 수 있다.

```bash
$ ls -l > list1.txt
# `w` 모드로 파일 작성 (새 파일 생성)

$ ls -l >> list2.txt
# `a` 모드로 파일 작성 (이전 파일에 덧붙임)

$ ls -zzzz &> listerror.txt
# 에러를 콘솔에 보여주지 않고 표준출력과 같이 파일에 저장

$ grep da * 2> errors.txt
# 에러를 errors.txt에 저장

$ less < errors.txt
# errors.txt의 내용을 입력으로 전달
```

---

이전 명령어의 `stdout`를 다음 명령어로 전달할 수 있다. `|`를 기준으로 이전 명령어의 결과가 다음 명령어의 입력으로 전달된다.

```bash
$ ls | grep readme | less
```

위 명령어는 아래와 같이 해석된다
```bash
$ ls
docs exercise readme.md
```

```bash
$ grep readme # in (docs exercise readme.md)
readme.md
```

```bash
$ less readme.md
```

이어진 명령어를 수행하다가 중간의 명령어가 실패하면 즉시 중단하도록 하기 위해서는 아래의 설정이 필요하다
```bash
$ set -o pipefail
```

---

