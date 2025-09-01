# Chezmoi Cheatsheet 🚀

## Quick Reference

### Basic Commands
```bash
# Check status
chezmoi status

# Apply all changes
chezmoi apply

# See what will change
chezmoi diff

# Edit a file
chezmoi edit ~/.zshrc

# Add a new file to dotfiles
chezmoi add ~/.config/myapp/config.toml

# Remove a file from dotfiles
chezmoi remove ~/.config/myapp/config.toml
```

## Installation & Setup

### First Time Setup
```bash
# Quick install (recommended)
export GITHUB_USERNAME=your-username
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

# Manual install
brew install chezmoi  # macOS
chezmoi init --apply your-username
```

### Reinitialize (if issues)
```bash
chezmoi init --apply your-username
```

## File Management

### Adding Files
```bash
# Add existing file to dotfiles
chezmoi add ~/.zshrc

# Add directory
chezmoi add ~/.config/nvim/

# Add with specific name
chezmoi add --name custom_config ~/.config/app/config.toml
```

### Editing Files
```bash
# Edit template file (recommended)
chezmoi edit ~/.zshrc

# Edit source file directly
vim ~/.local/share/chezmoi/dot_zshrc.tmpl

# Edit with specific editor
EDITOR=code chezmoi edit ~/.zshrc
```

### Removing Files
```bash
# Remove from dotfiles (keeps local file)
chezmoi remove ~/.zshrc

# Remove and delete local file
chezmoi remove --force ~/.zshrc
```

## Template Variables

### Built-in Variables
```bash
{{ .chezmoi.hostname }}     # Machine hostname
{{ .chezmoi.username }}     # Current username
{{ .chezmoi.homeDir }}      # Home directory
{{ .chezmoi.os }}           # Operating system
{{ .chezmoi.arch }}         # Architecture
{{ .chezmoi.sourceDir }}    # Source directory
```

### Custom Variables (from chezmoi.yaml)
```yaml
# In ~/.config/chezmoi/chezmoi.yaml
user:
  name: "your-name"
  email: "your-email@example.com"
  editor: "nvim"

# Use in templates
export EDITOR="{{ .user.editor }}"
export USER_NAME="{{ .user.name }}"
```

## Workflows

### Making Changes to Existing Files
```bash
# 1. Edit the template
chezmoi edit ~/.zshrc

# 2. Make changes in editor
# 3. Apply changes locally
chezmoi apply

# 4. Check what changed in repo
git status

# 5. Commit and push
git add .
git commit -m "Update zshrc configuration"
git push origin main

# 6. Reload shell
source ~/.zshrc
```

### Adding New Files
```bash
# 1. Add file to dotfiles
chezmoi add ~/.config/newapp/config.toml

# 2. Edit if needed
chezmoi edit ~/.config/newapp/config.toml

# 3. Apply changes
chezmoi apply

# 4. Commit and push
git add .
git commit -m "Add newapp configuration"
git push origin main
```

### Updating from Remote
```bash
# Update dotfiles from repository
chezmoi update

# Apply any changes
chezmoi apply

# Check for conflicts
chezmoi diff
```

## Advanced Commands

### Encryption
```bash
# Encrypt a file
chezmoi encrypt ~/.ssh/id_rsa

# Decrypt a file
chezmoi decrypt ~/.ssh/id_rsa

# Edit encrypted file
chezmoi edit ~/.ssh/id_rsa
```

### Scripts
```bash
# Run script once
chezmoi apply --run-scripts

# Run specific script
chezmoi apply --run-scripts=install-ansible.sh
```

### Dry Run
```bash
# See what would happen without applying
chezmoi apply --dry-run

# See differences
chezmoi diff
```

## Troubleshooting

### Common Issues
```bash
# Check Chezmoi health
chezmoi doctor

# Verify configuration
chezmoi verify

# Reset state (careful!)
chezmoi unmanaged
```

### Configuration Issues
```bash
# Multiple config files error
rm ~/.config/chezmoi/chezmoi.toml  # Keep only .yaml

# Source directory missing
chezmoi init --apply your-username
```

## Best Practices

### 1. Always Use Templates
```bash
# ✅ Good - uses template variables
export PROJECT_DIR="{{ .chezmoi.homeDir }}/projects"

# ❌ Bad - hardcoded paths
export PROJECT_DIR="/Users/username/projects"
```

### 2. Commit Regularly
```bash
# Check status before committing
chezmoi status
git status

# Use descriptive commit messages
git commit -m "Add Python development aliases"
git commit -m "Update FZF configuration for better search"
```

### 3. Test Changes
```bash
# Test before applying
chezmoi diff

# Apply and test
chezmoi apply
source ~/.zshrc
```

### 4. Use Machine-Specific Configs
```yaml
# In ~/.config/chezmoi/chezmoi.yaml
machine:
  name: "work-laptop"
  os: "darwin"

custom:
  aliases:
    - name: "work"
      command: "cd ~/work-projects"
```

## Integration with Ansible

### Using Makefile Commands
```bash
# Apply dotfiles
make chezmoi

# Install system packages
make install

# Test Ansible playbooks
make test

# Check status
make status
```

### Complete System Setup
```bash
# 1. Apply dotfiles
chezmoi apply

# 2. Install system packages
make install

# 3. Restart terminal or reload
source ~/.zshrc
```

## Useful Aliases

Add these to your `.zshrc`:
```bash
# Chezmoi shortcuts
alias cza='chezmoi apply'
alias cze='chezmoi edit'
alias czs='chezmoi status'
alias czd='chezmoi diff'
alias czu='chezmoi update'

# Git shortcuts for dotfiles
alias gdf='cd ~/.dotfiles'
alias gds='git status'
alias gdc='git commit -m'
alias gdp='git push origin main'
```

## Quick Commands Reference

| Command | Description |
|---------|-------------|
| `chezmoi status` | Check status of dotfiles |
| `chezmoi apply` | Apply all changes |
| `chezmoi diff` | Show differences |
| `chezmoi edit ~/.zshrc` | Edit a file |
| `chezmoi add ~/.file` | Add file to dotfiles |
| `chezmoi remove ~/.file` | Remove file from dotfiles |
| `chezmoi update` | Update from remote |
| `chezmoi doctor` | Check system health |
| `make chezmoi` | Apply dotfiles (via Makefile) |
| `make install` | Install system packages |

## Pro Tips

1. **Use `chezmoi edit`** instead of editing files directly
2. **Always `chezmoi diff`** before applying changes
3. **Commit frequently** with descriptive messages
4. **Use template variables** for machine-specific configs
5. **Test changes** before pushing to remote
6. **Keep secrets encrypted** with `chezmoi encrypt`
7. **Use the Makefile** for common operations
8. **Document custom configurations** in your README

---

**Remember**: Chezmoi manages your local files, Git manages your remote repository!
