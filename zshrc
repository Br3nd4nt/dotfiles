# =============================================================================
# ZSH Configuration
# =============================================================================

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
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
source /usr/local/bin/fzf-git

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
alias cls="clear && printf '\033[3J'"  # Полная очистка терминала

# Configuration editing
alias zcf="vim ~/.zshrc"
alias zs="source ~/.zshrc"

# =============================================================================
# Key Bindings
# =============================================================================
function clear-scrollback-buffer {
  # Behavior of clear: 
  # 1. clear scrollback if E3 cap is supported (terminal, platform specific)
  # 2. then clear visible screen
  # For some terminal 'e[3J' need to be sent explicitly to clear scrollback
  clear && printf '\e[3J'
  # .reset-prompt: bypass the zsh-syntax-highlighting wrapper
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  # -R: redisplay the prompt to avoid old prompts being eaten up
  # https://github.com/Powerlevel9k/powerlevel9k/pull/1176#discussion_r299303453
  zle && zle .reset-prompt && zle -R
}

zle -N clear-scrollback-buffer
bindkey '^L' clear-scrollback-buffer
