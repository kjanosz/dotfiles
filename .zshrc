# Emacs TRAMP does not like fancy prompts
[ "$TERM" != "dumb" ] || exec /bin/sh

# Set oh-my-zsh path for nixos and disable auto updates there
if [ -f "/run/current-system/sw/share/oh-my-zsh/oh-my-zsh.sh" ]; then
  DISABLE_AUTO_UPDATE="true"
  export ZSH="/run/current-system/sw/share/oh-my-zsh"
else
  git clone https://github.com/robbyrussell/oh-my-zsh $HOME/.oh-my-zsh
  export ZSH=$HOME/.oh-my-zsh
fi
ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache

ZSH_THEME="avit"
HYPHEN_INSENSITIVE="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(docker encode64 git pass vagrant)

. $ZSH/oh-my-zsh.sh

if [ -f "$HOME/.profile" ]; then
  . $HOME/.profile
fi

alias weechat='ssh -t kj@kjanosz.com docker exec -it im dtach -a /tmp/weechat'
