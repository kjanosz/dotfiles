gpg-connect-agent /bye > /dev/null 2>&1
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export BROWSER=firefox
export TERMINAL=termite
export PATH=$PATH:~/.local/bin