# 21-multiline

하나의 명령줄에 너무 긴 내용을 작성하면 가독성이 떨어진다.

`\` 키워드를 사용하여 한 줄로 작성된 아래 명령어를 여러 줄로 변환하시오.

## 명령어
```bash
$ curl -X POST https://reqbin.com/echo/post/json -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"id": "12345"}'
```

## 예시 정답
```bash
$ curl \
  -X POST \
  https://reqbin.com/echo/post/json \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"id": "12345"}'
```

# 참고

윈도우의 `powershell`에서는 ` ` `를 사용하여 줄바꿈을 수행한다.