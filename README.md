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

## Making Changes to Zshrc

### Step-by-Step Guide

1. **Edit the template file**:
   ```bash
   chezmoi edit zshrc
   ```
   This opens the template file `dot_zshrc.tmpl` in your default editor.

2. **Make your changes**:
   - Add new aliases, functions, or configurations
   - Modify existing settings
   - Add new plugin configurations

3. **Preview changes**:
   ```bash
   chezmoi diff
   ```
   This shows you exactly what will change when you apply.

4. **Apply changes**:
   ```bash
   chezmoi apply
   ```
   This updates your actual `~/.zshrc` file.

5. **Reload your shell** (optional):
   ```bash
   source ~/.zshrc
   ```
   Or simply restart your terminal.

### Alternative: Direct Template Editing

If you prefer to edit the template file directly:

1. **Navigate to the template**:
   ```bash
   cd ~/.config/chezmoi
   nvim dot_zshrc.tmpl
   ```

2. **Make changes and save**

3. **Apply changes**:
   ```bash
   chezmoi apply
   ```

### Template Variables

The zshrc template supports these variables (defined in `chezmoi.yaml`):
- `{{ .user.name }}` - Your name
- `{{ .user.email }}` - Your email
- `{{ .user.editor }}` - Your preferred editor

### Best Practices

- **Test changes**: Use `chezmoi diff` before applying
- **Backup**: Your original zshrc is preserved by Chezmoi
- **Version control**: All changes are tracked in your dotfiles repo
- **Machine-specific**: Use template variables for different machines

### Git Workflow (After Making Changes)

After applying your zshrc changes, commit and push to keep your dotfiles synchronized:

1. **Check what changed**:
   ```bash
   git status
   ```

2. **Add your changes**:
   ```bash
   git add .
   ```

3. **Commit with a descriptive message**:
   ```bash
   git commit -m "Update zshrc: add new aliases and functions"
   ```

4. **Push to remote repository**:
   ```bash
   git push origin main
   ```

5. **On other machines**, pull the changes:
   ```bash
   chezmoi update
   chezmoi apply
   ```

### Quick Git Commands

```bash
# One-liner for quick commits
git add . && git commit -m "Update dotfiles" && git push

# Check what's changed
git diff

# See commit history
git log --oneline -10
```

## Troubleshooting

- **Check status**: `make status`
- **Reapply**: `chezmoi apply`
- **Test**: `make test`
- **Help**: `chezmoi help`