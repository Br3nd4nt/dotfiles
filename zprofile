# ===========
# ZSH Profile
# ===========
echo "≽^•⩊•^≼ ₊˚⊹♡"
# =========================
# System PATH Configuration
# =========================
# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Java
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# ============================
# System Environment Variables
# ============================
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# ====================
# Editor Configuration
# ====================
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# =================
# Local Environment
# =================
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi


# Added by swiftly
[[ -f ~/.swiftly/env.sh ]] && . "/Users/br3nd4nt/.swiftly/env.sh"


# Added by Antigravity CLI installer
export PATH="/Users/br3nd4nt/.local/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export PATH="$HOME/.elan/bin:$PATH"
