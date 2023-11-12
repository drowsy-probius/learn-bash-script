# 02-basic-operation

[Reference](https://github.com/denysdovhan/bash-handbook)

---

다른 스크립트 언어와 유사하게 변수를 선언할 수 있다. `변수명=값`의 꼴로 선언하고 `=` 사이에 공백이 없어야한다.

값이 될 수 있는 타입은 숫자, 문자열, 배열, 딕셔너리이다.

```bash
$ NEW_NUM_VAR=1
$ NEW_STR_VAR="asdf"
$ NEW_ARR_VAR=("apple" "banana")

$ declare -A MY_ARR # >= bash 3.0
$ MY_ARR["key1"]=1
$ MY_ARR["key2"]=2
$ for key in "${!MY_ARR[@]}"; do
    echo "Key: $key, Value: ${MY_ARR[$key]}"
  done
Key: key1, Value: 1
Key: key2, Value: 2
```

---

변수를 문자열 내에서 사용할 때에는 쌍따옴표 `"`로 감싸고 변수 앞에 `$`를 덧붙인다. 따옴표 `'`를 사용하면 변수가 아니라 문자열로 해석한다.

```bash
$ VAR="world!"

$ echo "Hello $VAR"
Hello world!
$ echo 'Hello $VAR'
Hello $VAR
```


---

간단한 수식을 계산할 수 있다. `$(( ... ))`으로 감싼 내용을 계산한다.

```bash
$ a=1
$ b=2

$ echo $(( a + b ))
3

```

---

`{}`를 사용해서 간단하게 `for`문과 유사한 기능을 수행할 수 있다.

```bash
$ echo a{a,b,c,d}
aa bb cc dd # inline array

$ echo {00..8..2}
00 02 04 06 08
```

---

backtick 또는 `$()`으로 감싸서 중첩된 명령어를 수행하고 그 결과를 변수에 할당할 수 있다.

```bash
$ now=`date +%T`
$ now=$(date +%T)

$ echo $now
19:08:26
```

---

한 줄에 여러 개의 변수 할당이나 여러 개의 명령어를 수행할 수 있다. 변수 할당은 공백을 기준으로 이어 작성하고 명령어는 `;`를 구분자로 두어 작성한다.

```bash
$ VAR1=1 VAR2=2 VAR3=3
$ echo $(( $VAR1 + $VAR2 + $VAR3 ))
6



$ echo Hello! echo World! 
Hello! echo World

$ echo Hello!; echo World!
Hello!
World!
```

---

`&&`이나 `||`를 사용하여 이전 명령어의 정상 동작 여부에 따른 조건문을 구현할 수 있다.

```bash
$ ls &> /dev/null && echo "true" || echo "false"     
true

$ ls -zzzz &> /dev/null && echo "true" || echo "false"
false
```

---


