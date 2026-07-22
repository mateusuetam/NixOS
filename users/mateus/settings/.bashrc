#
# ~/.bashrc
#
[[ $- != *i* ]] && return

# ==== PS1 ====

FG_BLUE="\[\e[38;5;109m\]"
FG_GREEN="\[\e[38;5;142m\]"
FG_RED="\[\e[38;5;167m\]"
FG_SUBTEXT="\[\e[38;5;245m\]"
RESET="\[\e[0m\]"

set_prompt(){
local EXIT_STATUS=$?
local INDICATOR
if [[ $EXIT_STATUS -eq 0 ]]; then
INDICATOR="${FG_GREEN}◆"
else
INDICATOR="${FG_RED}◆"
fi
PS1=" ${INDICATOR} ${FG_SUBTEXT}\u@\h ${FG_BLUE}[\w]${RESET} ❯ "
}

PROMPT_COMMAND="set_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# ==== Funções ====

ex() {
[[ -f "$1" ]] || {
echo "'$1' arquivo inválido."
return 1
}

case "$1" in
*.tar.bz2) tar xjf "$1" ;;
*.tar.gz) tar xzf "$1" ;;
*.bz2) bunzip2 "$1" ;;
*.rar) unrar x "$1" ;;
*.gz) gunzip "$1" ;;
*.tar) tar xf "$1" ;;
*.tbz2) tar xjf "$1" ;;
*.tgz) tar xzf "$1" ;;
*.zip) unzip "$1" ;;
*.Z) uncompress "$1" ;;
*.7z) 7z x "$1" ;;
*) echo "'$1' não é um formato suportado." ;;
esac
}

# ==== Aliases e Readline ====

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -A1 --color=auto'
alias grep='grep --color=auto'
alias '..'='cd ..'
alias start='niri-session'
alias rmcache='rm -rf "$HOME"/.cache/*'

alias nrebuild='sudo nixos-rebuild switch --flake . --show-trace'
alias nupdate='nix flake update nixpkgs'
alias ngc='sudo nix-collect-garbage'
alias ngcall='sudo nix-collect-garbage -d'
alias nopt='sudo nix-store --optimise'

alias qsbin='quickshell -p "$HOME"/Repos/NixOS/quickshell/shell/shell.qml';
alias qsstart='systemctl start --user quickshell.service';
alias qsstatus='systemctl status --user  quickshell.service';
alias qsrestart='systemctl restart --user quickshell.service';
alias qsstop='systemctl stop --user quickshell.service';

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
