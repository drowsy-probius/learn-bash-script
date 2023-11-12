# 01-bash

[Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)

---

`Bourne shell (sh)`를 대체하기 위해 만들어진 Unix 계열 운영체제용 쉘.

---

대부분의 리눅스 운영체제의 기본 쉘. 현재 로그인한 사용자의 기본 쉘 설정은 아래 명령어를 통해 확인할  수 있음.

```bash
$ cat /etc/passwd | grep "$UID"
k123s4564h:x:1000:1000:k123,,,:/home/k123s456h:/bin/bash
```

참고로 Mac의 기본 쉘은 zsh이고 `/usr/bash` 경로에 bash가 설치되어 있긴 하지만 구버전(2.x)인 경우가 있음.

---

로그인 된 사용자의 개인 bash 설정 파일은 `~/.bashrc`, `~/.profile` 등에 위치함. 사용자가 bash 쉘에서 입력한 내용은 `~/.bash_history`에 위치하고 `history` 명령어로 이전 내역을 확인할 수 있음.

---

스크립트 파일을 작성할 때 해당 스크립트가 어떤 쉘에서 실행될 지 파일 상단에 지정한다. shebang이라고 부른다.

```bash
#!/usr/bin/bash
...
```

```bash
#!/usr/bin/env bash
...
```

위 두 shebang은 `bash`쉘로 해당 파일을 실행하도록 한다. 차이점은 전자는 어떤 사용자가 실행하는지 관계 없이 `/usr/bin/bash` 경로의 bash를 사용하지만 후자는 로그인한 사용자가 설정한 bash를 사용한다.
