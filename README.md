# Dotfiles

Мои конфигурационные файлы для macOS.

## Что установлено

- **ZSH** - с Oh My Zsh, FZF, Zoxide, Oh My Posh
- **Neovim** - современная конфигурация на Lua
- **Git** - глобальные настройки
- **FZF Git** - интеграция FZF с Git

## Установка

```bash
# Предварительный просмотр
./install.sh

# Установка
./install.sh --install
```

## Алиасы

- `gl` - git log с графиком
- `slf` - swiftlint --fix
- `cleands` - удаление .DS_Store
- `bubu` - brew update && upgrade
- `zcf` - редактирование .zshrc

## Обновление

```bash
cd ~/.dotfiles
git add .
git commit -m "Update"
git push
```
