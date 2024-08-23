#!/bin/zsh

# 1. 홈 디렉토리에 필요한 스크립트 파일들을 생성한다.
touch ~/walwal_fetch.sh
touch ~/walwal_generate_dev.sh
touch ~/walwal_generate_release.sh

# 2. 각 스크립트 파일에 내용을 추가한다.
echo '#!/bin/zsh
tuist fetch
rm -rf Tuist/Dependencies/Carthage/Checkouts/PinLayout/TestProjects
carthage build PinLayout --project-directory Tuist/Dependencies --platform iOS --use-xcframeworks --no-use-binaries --use-netrc --cache-builds --verbose
tuist fetch' > ~/walwal_fetch.sh

echo '#!/bin/zsh
TUIST_ENV=Dev tuist generate --config Debug' > ~/walwal_generate_dev.sh

echo '#!/bin/zsh
TUIST_ENV=release tuist generate --config Release' > ~/walwal_generate_release.sh

# 스크립트 파일들을 실행 가능하도록 설정한다.
chmod +x ~/walwal_fetch.sh
chmod +x ~/walwal_generate_dev.sh
chmod +x ~/walwal_generate_release.sh
chmod +x ~/.zshrc

# 새로운 명령어를 .zshrc 파일에 추가한다.
echo 'walwal() {
    if [ "$1" = "fetch" ]; then
        ~/walwal_fetch.sh
    elif [ "$1" = "generate" ]; then
        if [ "$2" = "dev" ]; then
            ~/walwal_generate_dev.sh
        elif [ "$2" = "release" ]; then
            ~/walwal_generate_release.sh
        else
            echo "Invalid generate option. Use 'dev' or 'release'."
        fi
    elif [ "$1" = "clean" ]; then
        tuist clean
    elif [ "$1" = "edit" ]; then
        tuist edit
    else
        echo "Invalid command. Available commands: fetch, generate (dev/release), clean, edit"
    fi
}' >> ~/.zshrc

# .zshrc 파일을 다시 로드하여 변경 사항을 즉시 적용한다.
source ~/.zshrc
