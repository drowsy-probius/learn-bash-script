# 04-conditions-and-loops

---

`if ...; then ... else ... fi` 키워드를 사용하여 조건문을 구성할 수 있다.

```bash
$ if [ 1 ];
then
  echo "True"
else
  echo "False"
fi

True
```

---

조건문에 들어가는 문법에 대해서는 파일, 문자열, 숫자, 부울 값에 따라서 다양하게 존재한다. [찾아보자](https://github.com/denysdovhan/bash-handbook#primary-and-combining-expressions)

```bash
# `-e`: 파일또는 폴더가 존재하면 True
$ if [ ! -e "not_exists_file.md" ];
then
  echo 1
fi

1
```

```bash
# `-f`: 파일이 존재하면 True
$ if [ ! -f "not_exists_file.md" ];
then
  echo 1
fi

1
```

```bash
# `-d`: 폴더가 존재하면 True
$ if [ ! -d "not_exists_file.md" ];
then
  echo 1
fi

1
```

```bash
# `-z`: 해당 문자열의 길이가 0이면 True
$ if [ -z "$NONE_VAR" ];
then
  echo 1
fi

1
```

---

배열을 이용하여 `for` 반복문을 구성할 수 있다.

```bash
$ for name in "Kim" "Lee";
do
  echo "$name"
done

Kim
Lee
```


---


조건을 명시하여 `while` 반복문을 구성할 수 있다. 유사하게 `until` 반복문을 구성할 수 있고 반대의 조건을 검사한다.


반복문 내에서는 `continue`, `break` 키워드를 사용할 수 있다.

```bash
$ x=0
$ while [[ $x -lt 10 ]]; do
  echo $(( x * x ))
  x=$(( x + 1 ))
done

0
1
4
9
16
25
36
49
64
81
```
