#!/bin/zsh

# 1. 홈 디렉토리에 walwal_fetch.sh 파일을 생성한다.
touch ~/walwal_fetch.sh

# 2. walwal_fetch.sh 파일을 만들고 아래의 내용을 추가한다. (TestProjects를 삭제하고 Carthage를 이용하여 PinLayout을 빌드)
# 참고 자료: [https://clamp-coding.tistory.com/486]
# - tuist fetch 명령어를 실행하여 프로젝트의 종속성을 설치한다.
# - 기존의 TestProjects폴더를 제거한다.
# - Carthage를 이용하여 PinLayout을 빌드한다.

echo '#!/bin/zsh
tuist fetch
rm -rf Tuist/Dependencies/Carthage/Checkouts/PinLayout/TestProjects
carthage build PinLayout --project-directory Tuist/Dependencies --platform iOS --use-xcframeworks --no-use-binaries --use-netrc --cache-builds --verbose
tuist fetch' > ~/walwal_fetch.sh

# 스크립트 파일을 실행 가능하도록 설정한다.
chmod +x ~/walwal_fetch.sh
chmod +x ~/.zshrc

# 새로운 명령어를 .zshrc 파일에 추가한다.
echo 'walwal() {
    if [ "$1" = "fetch" ]; then
        ~/walwal_fetch.sh
    elif [ "$1" = "generate" ]; then
        tuist generate
    elif [ "$1" = "clean" ]; then
        tuist clean
    elif [ "$1" = "edit" ]; then
        tuist edit
    else
        echo "Invalid command."
    fi
}' >> ~/.zshrc

# .zshrc 파일을 다시 로드하여 변경 사항을 즉시 적용한다.
source ~/.zshrc

