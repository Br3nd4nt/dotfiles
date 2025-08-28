# Dotfiles 🚀

Мои конфигурационные файлы для macOS.

## Что установлено

- **ZSH** - с Oh My Zsh, FZF, Zoxide, Oh My Posh
- **Neovim** - современная конфигурация на Lua
- **Git** - глобальные настройки
- **FZF Git** - интеграция FZF с Git (системная утилита)

## Установка

```bash
# Предварительный просмотр
./install.sh

# Установка
./install.sh --install

# Удаление (с восстановлением бэкапов)
./install.sh --uninstall --confirm
```

## Горячие клавиши

### FZF Git:
- `Ctrl+G Ctrl+F` - файлы
- `Ctrl+G Ctrl+B` - ветки
- `Ctrl+G Ctrl+T` - теги
- `Ctrl+G Ctrl+H` - коммиты

### FZF:
- `Ctrl+T` - поиск файлов
- `Ctrl+R` - история команд

### Терминал:
- `Ctrl+L` - полная очистка терминала

## Алиасы

### Git:
- `ga` - git add . --all
- `gc` - git commit -am
- `gco` - git checkout
- `gp` - git push origin HEAD
- `gs` - git status
- `gu` - git pull

### Система:
- `gl` - git log с графиком
- `slf` - swiftlint --fix
- `cleands` - удаление .DS_Store
- `bubu` - brew update && upgrade
- `zcf` - редактирование .zshrc
- `zs` - source ~/.zshrc

## Обновление

```bash
cd ~/.dotfiles
git add .
git commit -m "Update"
git push
```