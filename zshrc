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

# KITTY
alias icat="kitty +kitten icat"

# Neovim fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf Fuzzy Search
# TODO - learn how to use fzf
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh
