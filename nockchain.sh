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
# 기본세팅 시작하는 곳
echo -e "${BOLD}${CYAN} 기본 업데이트를 진행합니다. ${NC}"
sudo apt-get update && sudo apt-get upgrade -y

echo -e "${BOLD}${CYAN} 기본 패키지를 설치합니다. 오래 걸리니까 기다려주세용...${NC}"
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev libclang-dev llvm-dev -y

echo -e "${BOLD}${CYAN} curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -y

source $HOME/.cargo/env

echo -e "${BOLD}${CYAN} sudo sysctl -w vm.overcommit_memory=1 ${NC}"
sudo sysctl -w vm.overcommit_memory=1
# 기본세팅 끝나는 곳

echo -e "${BOLD}${CYAN} 이전 세팅을 지울게용 ${NC}"
# 마이너 스크린을 꺼요
screen -XS miner quit

# 녹체인을 지워요
rm -rf nockchain
rm -rf .nockapp

# 녹체인을 깔아보아요
echo -e "${BOLD}${RED} 이제 녹체인을 설치할 거에요~ 녹체인 돈 많이 벌길~ ㅎㅎ ${NC}"
git clone https://github.com/zorp-corp/nockchain

cd nockchain

# 파일을 카피해서 이름을 바꾸장
echo -e "${BOLD}${CYAN} cp .env_example .env ${NC}"
cp .env_example .env

# Hoonc를 깔아보아요
echo -e "${BOLD}${CYAN} make install-hoonc ${NC}"
make install-hoonc
export PATH="$HOME/.cargo/bin:$PATH"

echo -e "${BOLD}${CYAN} 지갑을 생성하기 위한 준비를 해 보아요 ㅎㅎ 오래 걸리니까 기다려 보아용 ${NC}"
make build

# 지갑을 생성해 보아요
echo -e "${BOLD}${CYAN} 지갑을 이제 만들 거에요. 지갑 만드는 명령어를 설치할게요~ ${NC}"
make install-nockchain-wallet
export PATH="$HOME/.cargo/bin:$PATH"

echo -e "${BOLD}${CYAN} 이번엔 녹체인 설치할 거에용. 오래 걸리니까 기다려요~ ${NC}"
make install-nockchain
export PATH="$HOME/.cargo/bin:$PATH"

#변경사항 최종 적용
echo -e "${RED} 변경사항 최종 적용 완료. ${NC}"
source ~/.bashrc
}

make_nock_wallet() {

#디렉토리 이동
cd ~/nockchain

echo -e "${BOLD}${YELLOW} 한 번 변경사항 저장하고 갈게요~ ${NC}"
export PATH="$HOME/.cargo/bin:$PATH"

echo -e "${BOLD}${RED} 이제 진짜로 지갑 만들 거에요~ 메모장 꺼내애앳!! ${NC}"
nockchain-wallet keygen

echo -ne "${BOLD}${MAGENTA} 아까 생성한 지갑 프라이빗키 여따가 치세염: ${NC}"
read -e private_key

echo -e "${BOLD}${YELLOW} 입력된 프라이빗키: ${private_key} ${NC}"

echo -e "${BOLD}${YELLOW} 프라이빗키 교체해 드릴게요~ ${NC}"
# .env 경로
env="$HOME/nockchain/.env"

# sed로 MINING_PUBKEY 값 바꾸기
sed -i "s|^MINING_PUBKEY=.*|MINING_PUBKEY=$private_key|" "$env"

echo -e "${BOLD}${CYAN} 프라이빗키 교체 완료~ ${NC}"
source ~/.bashrc
}

run_a_node() {
# .env 경로
env="$HOME/nockchain/.env"

# .env 파일에서 변수 뽑기
echo -e "${BOLD}${CYAN} 변수를 뽑는 중이에용... ${NC}"
source "$env"
export RUST_LOG
export MINIMAL_LOG_FORMAT
export MINING_PUBKEY

# 마이닝 실행
echo -e "${BOLD}${CYAN} 마이닝 시작하겠습니당 ${NC}"
nockchain --mining-pubkey "${MINING_PUBKEY}" --mine
}
# 메인 메뉴
echo && echo -e "${BOLD}${MAGENTA} NOCK CHAIN 자동 설치 스크립트${NC} by 코인러브미순
 ${CYAN}원하는 번호 입력하삼 ${NC}
 ———————————————————————
 ${GREEN} 1. 기본파일 설치 및 Nockchain 설치 1번(v1.4.0) ${NC}
 ${GREEN} 2. Nockchain 지갑 만들고 설정사항 바꿔보아요 ${NC}
 ${GREEN} 3. Nockchain을 실행해 보아요~ ${NC}
 ———————————————————————" && echo

# 사용자 입력 대기
echo -ne "${BOLD}${MAGENTA} 어떤 작업을 수행하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: ${NC}"
read -e num

case "$num" in
1)
    install_nock
    ;;
2)
    make_nock_wallet
    ;;
3)
    run_a_node
    ;;
*)
    echo -e "${BOLD}${RED} 비욘세의 Cowboy Carter 스트리밍하고 오세요. ${NC}"
    ;;
esac