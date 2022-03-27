# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=13
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Machine depended config
source ~/.zshrc_local

alias vim='nvim'
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias dotfiles="cd ~/.dotfiles"

# KITTY
if [ $TERM = "xterm-kitty" ]; then
 alias icat="kitty +kitten icat"
 alias setup_kitty_ssh="kitty +kitten ssh"
fi

# DOCKER
alias doc=docker
alias docc=docker-compose

# Neovim fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# TODO: read about fd file type selection (for neovim integration)
export FZF_DEFAULT_COMMAND="fd ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d"

# man highlighting with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
