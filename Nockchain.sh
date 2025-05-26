#!/bin/bash

BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
MAGENTA='\033[35m'
NC='\033[0m'

# 한국어 체크하기
check_korean_support() {
    if locale -a | grep -q "ko_KR.utf8"; then
        return 0  # Korean support is installed
    else
        return 1  # Korean support is not installed
    fi
}

# 한국어 IF
if check_korean_support; then
    echo -e "${CYAN}한글있어요. 설치 넘깁니다.${NC}"
else
    echo -e "${CYAN}한글없어요. 설치하겠습니다...${NC}"
    sudo apt-get install language-pack-ko -y
    sudo locale-gen ko_KR.UTF-8
    sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX
    echo -e "${CYAN} 설치 완료했어요~ ${NC}"
fi

install_nock() {
echo -e "${BOLD}${CYAN}  ${NC}"
echo -e "${BOLD}${CYAN} 기본 업데이트를 진행합니다. ${NC}"
sudo apt-get update && sudo apt-get upgrade -y

echo -e "${BOLD}${CYAN} 기본 패키지를 설치합니다. 오래 걸리니까 기다려주세용...${NC}"
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev libclang-dev llvm-dev -y

echo -e "${BOLD}${CYAN} curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo -e "${BOLD}${CYAN} sudo sysctl -w vm.overcommit_memory=1 ${NC}"
source $HOME/.cargo/env

echo -e "${BOLD}${CYAN} sudo sysctl -w vm.overcommit_memory=1 ${NC}"
sudo sysctl -w vm.overcommit_memory=1

echo -e "${BOLD}${CYAN} 이전 세팅을 지울게용 ${NC}"
# kill miner screen
screen -XS miner quit

# remove nockchain
rm -rf nockchain
rm -rf .nockapp

cp .env_example .env

make install-hoonc

export PATH="$HOME/.cargo/bin:$PATH"

make build

make install-nockchain-wallet

export PATH="$HOME/.cargo/bin:$PATH"

make install-nockchain

export PATH="$HOME/.cargo/bin:$PATH"
}



# 메인 메뉴
echo && echo -e "${BOLD}${MAGENTA} NOCK CHAIN 자동 설치 스크립트${NC} by 코인러브미순
 ${CYAN}원하는 번호 입력하삼 ${NC}
 ———————————————————————
 ${GREEN} 1. 기본파일 설치 및 Nockchain 설치 1번(v1.4.0) ${NC}
 ${GREEN} 2. Ritual Node 설치 2번(v1.4.0) ${NC}
 ${GREEN} 3. Ritual Node 설치 3번(v1.4.0) ${NC}
 ${GREEN} 4. Ritual Node가 멈췄어요! 재시작하기 ${NC}
 ${GREEN} 5. Ritual Node의 지갑주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 6. Ritual Node의 RPC 주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 7. Ritual Node를 업데이트하고 싶어요(12/15) ${NC}
 ${GREEN} 8. Ritual Node를 내 인생에서 지우고 싶어요 ${NC}
 ———————————————————————" && echo

# 사용자 입력 대기
echo -ne "${BOLD}${MAGENTA} 어떤 작업을 수행하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: ${NC}"
read -e num

case "$num" in
1)
    install_ritual
    ;;
2)
    install_ritual_2
    ;;
3)
    install_ritual_3
    ;;
4)
    restart_ritual
    ;;
5)
    change_Wallet_Address
    ;;
6)
    change_RPC_Address
    ;;
7)
    update_ritual
    ;;
8)
    uninstall_ritual
    ;;
*)
    echo -e "${BOLD}${RED} 번호 잘못 입력하신 듯... ㅎㅎ 다시 실행하시면 됩니다 ㅎㅎ${NC}"
    ;;
esac