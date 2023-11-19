# 웹 서버 코드 및 도커 빌드 설정

## 파일 개요
```bash
sample/image
| # 도커 이미지 빌드 설정
├── Dockerfile
| # 웹 서버 코드
└── index.js
```

## `Dockerfile`

```dockerfile
# node v20을 기본 이미지로 설정
FROM node:20.9.0

# pwd 지정
WORKDIR /app

# 웹 서버 코드 파일을 내부로 복사
COPY index.js /app/index.js

# 이미지의 실행 명령어 지정
ENTRYPOINT [ "node", "/app/index.js" ]
```


## `index.js`

```javascript
// http 모듈 임포트
const { createServer } = require('http');

// SIG_INT과 health check 시연을 위한 서버 업 다운 딜레이 설정
const startupDelay = Math.floor(Math.random() * 1000 * 5) + 3000
const shutdownDelay = Math.floor(Math.random() * 1000 * 5) + 3000

function sleep(time) { ... }

// os signal을 처리할 핸들러 함수 설정. 
// shutdownDelay만큼 기다린 후 서버 종료
function signalHandler(server) { ... }

// 기본 라우터 설정
// signalHandler 설정
// startupDelay 대기
// 3000 포트에서 서버 실행
async function main() { ... }

main();
```
