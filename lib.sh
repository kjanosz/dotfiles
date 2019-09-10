if [ -z "$1" ]; then
    echo "No environment provided"
    exit 1
fi

GREEN='\033[0;32m'
NC='\033[0m' # No Color

BASE=`dirname "$(readlink -f "$0")"`
ENV=$1

open_tomb() {
  echo -e "${GREEN}Opening tomb with secrets...${NC}"
  tomb open "$BASE/secrets.tomb" "$BASE/secrets" -k "$BASE/secrets.gpg" -g
}

close_tomb() {
  echo 
  echo -e "${GREEN}Closing tomb with secrets...${NC}"
  tomb slam secrets
}

set_trap() {
  trap '
    trap - INT # restore default INT handler
    close_tomb()
    kill -s INT "$$"
  ' INT
}

declare -A ENVS

etc_envs() {
  ENVS[kjanosz.com]="nixos kjanosz.com"
  ENVS[laptop]="nixos laptop"
}

home_envs() {
  ENVS[kjanosz.com]="default nixos kjanosz.com"
  ENVS[kj.laptop]="default nixos laptop kj.laptop"
  ENVS[kjw.laptop]="default nixos laptop kjw.laptop"
}
