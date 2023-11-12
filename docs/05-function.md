# 05-funciton

---

`함수이름() { ... }` 의 형식으로 함수를 선언할 수 있다.

함수의 인자는 `$1`, `$2`, ...를 통해서 참조할 수 있다.

참고로 `$0`은 함수의 이름을 가리킨다.


`function 함수이름() { ... }` 으로 선언할 수 있고 동일한 동작을 수행하지만 호환성을 보장하지 않는다.

```bash
$ hello(){
  NAME=${1:-"World"}
  echo "Hello! $NAME"
}

$ hello
Hello! World
$ hello Kim
Hello! Kim
```

