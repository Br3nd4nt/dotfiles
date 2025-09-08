# Python Environment Management

Your Python environment has been cleaned up and modernized using **uv** - a fast Python package and project manager.

## What Was Cleaned Up

**Removed:**
- Pyenv installation and configuration
- Pyenv-managed Python versions  
- Conflicting PATH entries

**Kept:**
- System Python 3.9.6 (required by macOS)
- Homebrew Python 3.13.7 (required by other packages)

**Added:**
- uv (modern Python manager)
- Clean PATH configuration

## Quick Start

### Basic Commands

```bash
# Check uv version
uv --version

# List available Python versions
uv python list

# Install a specific Python version
uv python install 3.12

# Create a new project
uv init my-project
cd my-project

# Add packages
uv add requests numpy

# Run Python scripts
uv run python script.py
```

### Project Workflow

```bash
# Create project with specific Python version
uv init my-project --python 3.12

# Add dependencies
uv add requests "numpy>=1.20.0"
uv add pytest --dev

# Run commands
uv run python main.py
uv run pytest
uv run jupyter notebook
```

## Common Commands

### Python Versions
```bash
uv python install 3.12          # Install Python 3.12
uv python list                  # List available versions
uv python pin 3.12             # Pin version for project
```

### Package Management
```bash
uv add requests                 # Add package
uv add pytest --dev            # Add dev dependency
uv remove requests              # Remove package
uv sync --upgrade              # Update packages
```

### Virtual Environments
```bash
uv venv                        # Create venv
uv run python script.py        # Run in venv
uv run pytest                  # Run command in venv
```

## Troubleshooting

**Command not found: uv**
```bash
export PATH="$HOME/.local/bin:$PATH"
```

**Python version not found**
```bash
uv python install 3.12
```

**Package issues**
```bash
uv self update
uv cache clean
```

## Benefits

- ✅ **10-100x faster** than pip
- ✅ **No version conflicts**
- ✅ **Easy project setup**
- ✅ **Modern tooling**

---

*For more details, run `uv --help` or visit [uv documentation](https://docs.astral.sh/uv/).*
