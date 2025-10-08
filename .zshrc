# Source credentials if it exists
if [ -f "$HOME/.zsh/credentials.zsh" ]; then
  source "$HOME/.zsh/credentials.zsh"
fi

export ZSH_DISABLE_COMPFIX="true"
export DISABLE_UPDATE_PROMPT="true"
export CASE_SENSITIVE="true"
export EDITOR='nvim'


export HIST_STAMPS="dd/mm/yyyy"
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
export HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
set -o emacs


# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

export GOPATH=~/go
export GOBIN="$GOPATH/bin"
export GO111MODULE=on

export PATH="$PATH:$GOBIN"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$PATH:${HOME}/.bun/bin"

export ZSH_COMP_DIR=`echo "$HOME/.zsh/completions"`
if [ ! -d $ZSH_COMP_DIR ]; then
  mkdir -p $ZSH_COMP_DIR
fi
if [ -n "$ZSH_CACHE_DIR" ] && [ ! -d "$ZSH_CACHE_DIR/completions" ]; then
  mkdir -p $ZSH_CACHE_DIR/completions
fi

export PATH="$PATH:$HOME/.local/bin"

export PATH="/opt/homebrew/bin:$PATH"

if [ -f $HOME/playground/tools/bash-insulter/src/bash.command-not-found ]; then
    . $HOME/playground/tools/bash-insulter/src/bash.command-not-found
else
  git clone https://github.com/hkbakke/bash-insulter.git $HOME/playground/tools/bash-insulter/
  . $HOME/playground/tools/bash-insulter/src/bash.command-not-found
fi

if [ $(command -v yarn) ]; then
  export PATH=$PATH:$(yarn global bin)
fi

# export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"

function take (){
 mkdir $1
 cd $1
}

if [ -d $ASDF_DIR ]; then
  export fpath=($ZSH_CACHE_DIR/completions $ZSH_COMP_DIR/ ${ASDF_DIR}/completions/ $fpath)
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zi light Aloxaf/fzf-tab

zi light zdharma/fast-syntax-highlighting
zi light zsh-users/zsh-completions
zi light zsh-users/zsh-autosuggestions

zi ice as"completion"
zi snippet OMZP::lein/_lein

zi ice as"completion"
zi snippet OMZP::httpie/_httpie

zi snippet OMZL::git.zsh
zi snippet OMZL::directories.zsh

zi snippet OMZP::brew
zi snippet OMZP::git
zi snippet OMZP::aliases
zi snippet OMZP::golang
zi snippet OMZP::sudo
zi snippet OMZP::fzf
zi snippet OMZ::plugins/rust
zi load atuinsh/atuin

autoload -U compinit && compinit
zinit cdreplay -q

autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

if [ $(command -v go-blueprint) ]; then
   source <(go-blueprint completion zsh)
fi

eval "$(starship init zsh)"

SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

function sga {
    pkill gpg-agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
}

sga

eval "$(zoxide init --cmd cd zsh)"

zoxide_session_detached() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided."
    return 1
  fi

  for arg in "$@"; do
    found=$(zoxide query -l "$arg")
    if [ -z "$found" ]; then
      echo "No result found from zoxide query."
      return 1
    fi

    # If there's only one match, use it directly
    if [ "$(echo "$found" | wc -l)" -eq 1 ]; then
      selection="$found"
    else
      selection=$(echo "$found" | fzf)
      if [ -z "$selection" ]; then
        echo "No selection made in fzf."
        return 1
      fi
    fi

    last="${selection##*/}"
    ## Remove leading dot
    last="${last#.}"
    tmux new -d -t "$last" -c "$selection"

  done
}

zoxide_session() {
  zoxide_session_detached "$@"

  if [ -n "$TMUX" ]; then
    return $?
  fi

  tmux attach
}

export GPG_RECIPIENT="yuhri.graziano@gmail.com"

function yubi_encrypt() {
  # Remove or comment out the strict mode lines:
  # setopt errexit nounset pipefail

  if [[ $# -lt 1 ]]; then
    echo "Usage: yubi_encrypt <file_to_encrypt> [<output_file>]"
    return 1
  fi

  local input_file=$1
  local output_file=${2:-"${input_file}.gpg"}

  gpg --encrypt \
      --recipient "$GPG_RECIPIENT" \
      --output "$output_file" \
      "$input_file"

  echo "Encrypted '$input_file' -> '$output_file' (recipient: $GPG_RECIPIENT)"
}

function yubi_decrypt() {
  # setopt errexit nounset pipefail

  if [[ $# -lt 1 ]]; then
    echo "Usage: yubi_decrypt <file_to_decrypt> [<output_file>]"
    return 1
  fi

  local enc_file=$1
  local dec_file

  if [[ $# -ge 2 ]]; then
    dec_file="$2"
  else
    if [[ "$enc_file" == *.gpg ]]; then
      dec_file="${enc_file%.gpg}"
    else
      dec_file="${enc_file}.dec"
    fi
  fi

  gpg --decrypt \
      --output "$dec_file" \
      "$enc_file"

  echo "Decrypted '$enc_file' -> '$dec_file'."
}

tmux_kill_session() {
  found=$(tmux ls 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: tmux is not running or no sessions found."
    return 1
  fi

  if [ -z "$found" ]; then
    echo "No tmux sessions found."
    return 1
  fi

  # If there's only one match, use it directly
  if [ "$(echo "$found" | wc -l)" -eq 1 ]; then
    selection="$found"
  else
    selection=$(echo "$found" | fzf)
    if [ -z "$selection" ]; then
      echo "No selection made in fzf."
      return 1
    fi
  fi

  session_name=$(echo "$selection" | awk -F: '{print $1}')

  tmux kill-session -t "$session_name"
}

setup_rust(){
    cargo install sqlx-cli
    cargo install cargo-watch
    cargo install cargo-outdated
    cargo install cargo-audit
    cargo install cargo-release
}

alias k=kubectl
alias kgpa='kubectl get pods --all-namespaces'

alias ctop='TERM=xterm-256color ctop'

alias t='tmux'
alias ta='tmux attach'
alias tas='tmux attach -t'
alias tl='tmux ls'
alias tn='tmux new'
alias tnd='tmux new -d'
alias tns='tmux new -t'
alias tnsd='tmux new -d -t'
alias tk='tmux_kill_session'
alias tka='tmux kill-server'
alias tz='zoxide_session'
alias tzd='zoxide_session_detached'

alias l='lsd'
alias ls='lsd -lah --color=always --group-directories-first --icon=always'
alias la='lsd -lah --color=always --group-directories-first --icon=always'
alias laa='lsd -lah --total-size --color=always --group-directories-first --icon=always'
alias lsa='lsd -lh --total-size --color=always --group-directories-first --icon=always'
alias lt='lsd -a --tree --color=always --group-directories-first --icon=always'

alias poly='clojure -M:poly'

alias d='docker'
# compose
alias dc='docker compose'

if [ $(command -v gsed) ]; then
    alias sed='gsed'
fi

alias n='nvim'

alias fgco='git checkout `git branch | fzf`'
alias lg=lazygit

eval "$(mise activate zsh)"

# bun completions
[ -s "/Users/yuhrao/.bun/_bun" ] && source "/Users/yuhrao/.bun/_bun"
