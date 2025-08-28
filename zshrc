# =============================================================================
# ZSH Configuration - User Settings
# =============================================================================
# This file is loaded for each terminal session

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git fzf-docker)

# =============================================================================
# Load Oh My Zsh
# =============================================================================
source $ZSH/oh-my-zsh.sh

# =============================================================================
# Shell Enhancements
# =============================================================================
# Oh My Posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# FZF Git integration
source ~/.config/fzf-git.sh/fzf-git.sh

# =============================================================================
# FZF Configuration
# =============================================================================
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

# =============================================================================
# Python Environment
# =============================================================================
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# =============================================================================
# Editor Aliases
# =============================================================================
if [[ -z $SSH_CONNECTION ]]; then
  alias vim=nvim
  alias v=nvim
fi

# =============================================================================
# User Aliases
# =============================================================================
# File management
alias cleands='find . -name ".DS_Store" -type f -delete'
alias cd=z

# Development tools
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias slf="swiftlint --fix"

# System utilities
alias bubu="brew update && brew upgrade"

# Configuration editing
alias zcf="vim ~/.zshrc"
