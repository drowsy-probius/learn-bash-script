# 20-script-directory

스크립트를 실행하면서 사용자의 현재 `pwd`에 상관 없이 스크립트가 실행될 때 스크립트가 위치한 디렉토리로 이동하고자 한다. 

`SCRIPT_DIR` 변수에 스크립트가 위치한 경로를 할당한다.

## 결과
```bash
$ pwd
/config/workspace/learn-bash-script/exercise/20-script-directory
$ /config/workspace/learn-bash-script/exercise/20-script-directory/main.sh
/config/workspace/learn-bash-script/exercise/20-script-directory

$ cd /
$ pwd
/
$ /config/workspace/learn-bash-script/exercise/20-script-directory/main.sh
/config/workspace/learn-bash-script/exercise/20-script-directory
```

# 참고
```bash
$ echo $0
bash
```

```bash
$ dirname /config/workspace 
/config

$ readlink -f /config/workspace 
/config/workspace
```

```bash
$ realpath ./exercise
/config/workspace/learn-bash-script/exercise
```