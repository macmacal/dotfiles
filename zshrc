# Plugins
# ===========================================================================
    
    # Load Antibody plugin manager
    export PATH=$HOME/.local/bin:$PATH
    source <(antibody init)
   
    # Setup env vars for ohmyzsh
    export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh"

    antibody bundle ohmyzsh/ohmyzsh
    
    # Adds cpv function based on rsync
    antibody bundle ohmyzsh/ohmyzsh path:plugins/cp

    # Docker autocomplete
    antibody bundle ohmyzsh/ohmyzsh path:plugins/docker
    antibody bundle ohmyzsh/ohmyzsh path:plugins/docker-compose
    
    # Git autocomlete
    antibody bundle ohmyzsh/ohmyzsh path:plugins/git
    # antibody bundle ohmyzsh/ohmyzsh path:plugins/git-flow

    # Adds `extract` function for any archive filetype
    antibody bundle ohmyzsh/ohmyzsh path:plugins/extract

    # Integration with fzf and fd commands
    antibody bundle ohmyzsh/ohmyzsh path:plugins/fzf
    antibody bundle ohmyzsh/ohmyzsh path:plugins/fd
    
    # Adds `jump` and `mark` commands for directories
    antibody bundle ohmyzsh/ohmyzsh path:plugins/jump

    # Informative alliases for nmap syntax
    antibody bundle ohmyzsh/ohmyzsh path:plugins/nmap

    # Autocompletion for pip
    antibody bundle ohmyzsh/ohmyzsh path:plugins/pip

    # Aliases for frequent rsync commands
    antibody bundle ohmyzsh/ohmyzsh path:plugins/rsync
    
    # Integration with `z` command for jumping to the most recent directories
    antibody bundle ohmyzsh/ohmyzsh path:plugins/z

    # TODO: Read about ack
    # antibody bundle sampson-chen/sack
    
    # Grey-autosugesstion
    antibody bundle zsh-users/zsh-autosuggestions

    # Fish-like highlight (must be the last)
    antibody bundle zsh-users/zsh-syntax-highlighting

    # Theme
    antibody bundle ohmyzsh/ohmyzsh path:themes/agnoster.zsh-theme

# // Plugins


# Configuration
# ===========================================================================
    
    HYPHEN_INSENSITIVE="true"
    COMPLETION_WAITING_DOTS="true"
    HIST_STAMPS="yyyy-mm-dd"
    #ZSH_THEME="agnoster"

    # PATH
    typeset -U path cdpath fpath
    path=(
        $HOME/.local/bin
        $HOME/.bin
        $HOME/bin
        $path
    )

    # Neovim usage
    export EDITOR='nvim'
    export GIT_EDITOR='nvim'
    if [[ -n $SSH_CONNECTION ]]; then
      export EDITOR='nvim'
    else
      export EDITOR='nvim'
    fi

    # man highlighting with bat
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# // Configuration


# Aliases & functions
# ===========================================================================

    # VARIA
    alias bat='batcat'
    alias cat='bat'
    alias copy='xclip -selection clipboard'
    alias dotfiles="cd ~/.dotfiles"
    alias paste='xclip -o -selection clipboard'
    alias vim='nvim'
    
    # KITTY
    if [ $TERM = "xterm-kitty" ]; then
      alias copy="kitty +kitten clipboard"
      alias icat="kitty +kitten icat"
      alias kitty_setup_ssh="kitty +kitten ssh"
      alias paste="kitty +kitten clipboard --get-clipboard"
    fi

    # DOCKER
    alias doc=docker
    alias docc=docker-compose

    # GIT
    alias g='git'
    alias ga='git add'
    alias gs='git status'

    # SCRIPTS
    alias checksum="~/.scripts/checksums.sh"

    # Neovim fuzzy finder
    # [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # fzf TODO read more about ack/ag commands and usage with fzf + fd
    # source /usr/share/fzf/key-bindings.zsh
    # source /usr/share/fzf/completion.zsh
    # TODO Fix for ubuntu
    # source /usr/share/doc/fzf/examples/key-bindings.zsh
    # source /usr/share/doc/fzf/examples/completion.zsh
    # TODO: read about fd file type selection (for neovim integration)
    # export FZF_DEFAULT_COMMAND="fd ."
    # export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # export FZF_ALT_C_COMMAND="fd --type d"

# // Aliases & functions


# Machine depended config
# ===========================================================================
    source ~/.zshrc_local
