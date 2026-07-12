# ==================
# ZSH Configuration
# ==================
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# =======================
# Homebrew Configuration
# =======================

export HOMEBREW_AUTO_UPDATE_SECS=604800

# Swift toolchain
export PATH="/opt/homebrew/opt/swift/bin:$PATH"

# =======================
# Oh My Zsh Configuration
# =======================
export ZSH="$HOME/.oh-my-zsh"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(
    git
    fzf-docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    you-should-use
    zsh-bat
)

# ==============
# Load Oh My Zsh
# ==============
source $ZSH/oh-my-zsh.sh

# ==================
# Shell Enhancements
# ==================
# Oh My Posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/omp.yml)"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# FZF Git integration
source /usr/local/bin/fzf-git

# =================
# FZF Configuration
# =================
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=d"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --hidden --exclude .git --type=d . "$1"
}

# ==================
# Python Environment (uv)
# ==================
# uv is now the primary Python version manager
# Add uv to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# uv configuration
export UV_SYSTEM_PYTHON=1

# rust 
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ==============
# Editor Aliases
# ==============
alias vim=nvim
alias v=nvim
alias code=codium

# ============
# User Aliases
# ============

# Basic aliases
alias l='ls'
alias ll='ls -lahG'
alias suod='sudo'
alias grep='rg'
alias fman="compgen -c | fzf | xargs tldr"

alias twt='npx twt-dl-cli@latest'
alias neofetch="hyfetch"
alias htop="btop"

# Color support
grep --color=auto < /dev/null &>/dev/null && alias grep='grep --color=auto'
xdg-open --version &>/dev/null && alias open='xdg-open'

# Enable color support of ls
if ls --color=auto &>/dev/null; then
	alias ls='ls -p --color=auto'
else
	alias ls='ls -p -G'
fi

ip() {
    #global ip
    printf "global: "
    curl ipv4.icanhazip.com
    #local ip
    printf "local: "
    ifconfig en0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
}

# File management
alias cleands='command find . -name ".DS_Store" -type f -delete'
alias cd=z
alias ls=eza
alias find=fd

alias tree="tree -alx -L 5 -R --gitignore -I ".git" -I ".swiftlint" -I ".gitignore" --filelimit 50 -A -C"

_spm_clean() {
    rm Package.resolved
    rm -rf .build
    rm -rf *.xcodeproj
    rm -rf Packages
}

alias spm-clean='_spm_clean'


# Development tools
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias slf="swiftlint --fix"

# System utilities
alias bubu="brew update && brew upgrade"

# Configuration editing
alias zcf="vim ~/.zshrc"
alias zs="source ~/.zshrc"

# Git aliases
alias ga='git add . --all'
alias gb='git branch'
alias gcl='git clone'
alias gc='git commit -am'
alias gco='git checkout'
alias gd="git diff ':!*lock'"
alias gi='git init'
alias gl='git log'
alias gp='git push origin HEAD'
alias gs='git status'
alias gu='git pull' # gu = git update

# ============
# Key Bindings
# ============
function clear-scrollback-buffer {
  clear && printf '\e[3J'
  zle && zle .reset-prompt && zle -R
}

zle -N clear-scrollback-buffer
bindkey '^L' clear-scrollback-buffer
