# sample 코드 개요 

## 파일 개요
```bash
sample
│ # nginx 설정 파일
├── conf.d
│   ├── common
│   │   ├── common.conf
│   │   └── proxy.conf
│   ├── default.conf
│   │ # 리버스 프록시 설정
│   ├── server
│   │   └── localhost.conf
│   │ # 프록시 대상이 되는 서버 설정 (링크파일로 연결)
│   ├── upstream
│   │   └── web-api.conf -> ../upstream-green/web-api.conf
│   ├── upstream-blue
│   │   └── web-api.conf
│   └── upstream-green
│       └── web-api.conf
│ # 환경변수 파일 저장
├── env
│ # 도커 이미지 및 앱 빌드 관련 설정
├── image
│   ├── Dockerfile
│   └── index.js
│ # 앱 초기 설정 및 앱 실행 (web-api, api-gateway)
├── init.sh
│ # 공용 함수 선언
├── launch_functions.sh
│ # 컨테이너가 사용하는 브릿지 네트워크 인터페이스 목록 출력
├── map_nic_and_container.sh
│ # 현재 실행중인 모든 컨테이너의 목록 출력
├── monitor.sh
│ # web-api에 해당되는 컨테이너 강제종료 및 삭제
├── shutdown.sh
│ # web-api 버전을 다른 버전으로 전환 (blue <-> green)
└── switch.sh
```

## [app-config](./app-config.md)

## [nginx-config](./nginx-config.md)

## [script-miscellaneous](./script-miscellaneous.md)

## [script-entrypoint-1.md](./script-entrypoint-1.md)

## [script-entrypoint-2.md](./script-entrypoint-2.md)

