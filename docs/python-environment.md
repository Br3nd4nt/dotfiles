# Python Environment

Modern Python management with **uv** - fast, clean, conflict-free.

## Quick Start

```bash
# New project
uv init my-project
cd my-project

# Add packages
uv add requests numpy

# Run code
uv run python main.py
```

## Essential Commands

| Task | Command |
|------|---------|
| **Python** | `uv python install 3.12` |
| **Packages** | `uv add requests` |
| **Dev deps** | `uv add pytest --dev` |
| **Run** | `uv run python script.py` |
| **Update** | `uv sync --upgrade` |

## Troubleshooting

```bash
# uv not found
export PATH="$HOME/.local/bin:$PATH"

# Python missing
uv python install 3.12

# Package issues
uv self update && uv cache clean
```

**Benefits:** 10-100x faster than pip • No version conflicts • Modern tooling
