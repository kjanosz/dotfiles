if [ -f "$HOME/.zshrc.base" ]; then
  . $HOME/.zshrc.base
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

if [ -f "$HOME/.zshrc.local" ]; then
  . $HOME/.zshrc.local
fi
