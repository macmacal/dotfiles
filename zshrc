# Plugins manager
# ===========================================================================

    export PATH=${HOME}/.antidote:$PATH
    ANTIDOTE_DIR=${HOME}/.antidote

    # Load Antidote plugin manager
    source ${ANTIDOTE_DIR}/antidote.zsh

    # Set the root name of the plugins files (.txt and .zsh) antidote will use.
    zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

    # Ensure the .zsh_plugins.txt file exists so you can add plugins.
    [[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

    # Setup the OMZ theme
    ZSH_THEME=agnoster

    # Lazy-load antidote from its functions directory.
    fpath=(${ANTIDOTE_DIR}/functions $fpath)
    autoload -Uz antidote

    # Generate a new static file whenever .zsh_plugins.txt is updated.
    if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
      antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
    fi

    # Source your static plugins file.
    source ${zsh_plugins}.zsh


# // Plugins manager

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


# // Configuration


# Aliases & functions
# ===========================================================================

    # VARIA
    alias copy='xclip -selection clipboard'
    alias dotfiles="cd ~/.dotfiles"
    alias paste='xclip -o -selection clipboard'
    alias vim='nvim'
    alias r='. ranger'

    # Enable usage of asterisk ('*') like in bash
    setopt extended_glob

    # Follow directory opened in ranger
    alias r='. ranger'

    # KITTY
    if [ $TERM = 'xterm-kitty' ]; then
      alias copy='kitty +kitten clipboard'
      alias icat='kitty +kitten icat'
      alias kitty_setup_ssh='kitty +kitten ssh'
      alias paste='kitty +kitten clipboard --get-clipboard'
    fi

    # DOCKER
    alias doc='docker'
    alias docc='docker compose'

    # SCRIPTS
    alias checksum='~/.scripts/checksums.sh'
    alias dwm_install='~/.scripts/recompile_dwm_dmenu.sh'
    alias gitler='~/.scripts/gitler.sh'

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
# // Machine depended config
