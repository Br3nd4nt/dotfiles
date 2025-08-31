# Installation Guide

## Quick Install (Recommended)

```bash
export GITHUB_USERNAME=br3nd4nt
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## What This Does

1. **Installs Chezmoi** - The dotfile manager
2. **Clones this repository** - Your dotfiles
3. **Applies all configurations** - Sets up your shell, editor, etc.
4. **Installs Ansible** - For system automation
5. **Configures your system** - Installs packages and tools

## Manual Installation

If you prefer manual installation:

```bash
# 1. Install Chezmoi
brew install chezmoi  # macOS
# or
curl -fsLS get.chezmoi.io | sh  # Linux

# 2. Apply dotfiles
chezmoi init --apply br3nd4nt

# 3. Run system configuration
cd ~/.dotfiles
make install
```

## After Installation

- **Restart your terminal** or run `source ~/.zshrc`
- **Customize your configuration** in `~/.config/chezmoi/chezmoi.yaml`
- **Add your SSH keys** to `~/.ssh/`
- **Configure Git** with your name and email

## Troubleshooting

- **Check status**: `make status`
- **Test configuration**: `make test`
- **Reapply dotfiles**: `chezmoi apply`
- **Get help**: `chezmoi help`
