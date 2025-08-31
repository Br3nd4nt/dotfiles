# Chezmoi Scripts

This directory contains Chezmoi `run_once` scripts that execute only once when dotfiles are first applied to a new machine.

## Scripts Overview

### `run_once_install-ansible.sh.tmpl`
- **Purpose**: Installs Ansible and required collections
- **When**: Runs once per machine during initial setup
- **OS Support**: macOS and Linux
- **What it does**:
  - Checks if Ansible is already installed
  - Installs Ansible via Homebrew (macOS) or package manager (Linux)
  - Installs Ansible collections from `ansible/requirements.yml`
  - Provides feedback on installation status

### `run_once_install-darwin.sh.tmpl`
- **Purpose**: macOS-specific system setup
- **When**: Runs once per macOS machine during initial setup
- **OS Support**: macOS only
- **What it does**:
  - Installs Homebrew if not present
  - Installs essential macOS packages and applications
  - Sets up Oh My Zsh
  - Configures macOS-specific tools

### `run_once_install-linux.sh.tmpl`
- **Purpose**: Linux-specific system setup
- **When**: Runs once per Linux machine during initial setup
- **OS Support**: Linux only
- **What it does**:
  - Detects Linux distribution (Ubuntu/Debian, Fedora, etc.)
  - Installs system packages via appropriate package manager
  - Sets up Linux-specific tools and configurations
  - Installs development tools

## How Chezmoi Run-Once Scripts Work

1. **Template Processing**: Scripts are processed as templates, so they can use Chezmoi variables
2. **One-Time Execution**: Each script runs only once per machine
3. **Automatic Detection**: Chezmoi automatically detects and runs appropriate scripts
4. **Error Handling**: Scripts include error checking and feedback

## Adding New Scripts

To add a new run_once script:

1. Create the script in this directory with `.tmpl` extension
2. Use descriptive naming: `run_once_<purpose>.sh.tmpl`
3. Include proper error handling and feedback
4. Use Chezmoi template variables when needed
5. Test on target platform before committing

## Example Script Structure

```bash
#!/bin/bash
# Chezmoi run_once script for <purpose>
# Runs only once when dotfiles are first applied

echo "Setting up <feature> for {{ .chezmoi.hostname }}..."

# Check if already done
if [ -f ~/.chezmoi-<feature>-installed ]; then
    echo "<feature> is already installed"
    exit 0
fi

# Your installation logic here
# ...

# Mark as installed
touch ~/.chezmoi-<feature>-installed
echo "<feature> installation complete!"
```

## Best Practices

1. **Always check if already installed** to avoid re-running
2. **Use template variables** for machine-specific configurations
3. **Provide clear feedback** about what's happening
4. **Handle errors gracefully** with appropriate exit codes
5. **Mark completion** to prevent re-execution
6. **Test thoroughly** on target platforms
7. **Document dependencies** and requirements

## Troubleshooting

If a script fails or needs to be re-run:

```bash
# Remove the completion marker
rm ~/.chezmoi-<feature>-installed

# Re-run the script
chezmoi apply --run-scripts
```

## Integration with Ansible

These scripts work alongside your Ansible playbooks:
- **Scripts**: Handle one-time setup and installation
- **Ansible**: Handle ongoing configuration and package management
- **Chezmoi**: Manages the overall dotfiles application process
