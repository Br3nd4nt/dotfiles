# Dotfiles - Personal Cheatsheet

My dotfiles setup using Chezmoi + Ansible.

## Quick Install

```bash
export GITHUB_USERNAME=br3nd4nt
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## Commands I Need to Remember

### Chezmoi
```bash
chezmoi apply          # Apply changes
chezmoi diff           # See what would change
chezmoi edit zshrc     # Edit a template
chezmoi status         # Check status
```

### Ansible
```bash
make install           # Install Ansible + run config
make ansible           # Install Ansible only
make test              # Test playbooks
make status            # Check what's installed
```

### Adding New Files
```bash
chezmoi add ~/.config/newapp/config.yml
chezmoi forget ~/.config/oldapp/     # Remove from tracking
```

## What Gets Installed

- **Shell**: Zsh + Oh My Zsh + Oh My Posh
- **Terminal**: Ghostty
- **Editor**: Neovim with Lazy.nvim
- **Tools**: FZF, fd, ripgrep, zoxide, htop
- **Dev**: Python (pyenv), Node.js, Go, Rust
- **Package Managers**: Homebrew (macOS), apt/dnf (Linux)

## Customize

Edit `~/.config/chezmoi/chezmoi.yaml` for your machine:
```yaml
user:
  name: "Your Name"
  email: "your.email@example.com"
  editor: "nvim"
```

## Project Structure

```
~/.dotfiles/
├── ansible/           # System automation
├── dot_config/        # App configs (Chezmoi templates)
├── scripts/           # Chezmoi run_once scripts
├── dot_zshrc.tmpl    # Shell config
├── dot_gitconfig.tmpl # Git config
└── Makefile          # Quick commands
```

## Troubleshooting

- **Check status**: `make status`
- **Reapply**: `chezmoi apply`
- **Test**: `make test`
- **Help**: `chezmoi help`