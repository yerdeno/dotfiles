#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_message() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Проверка наличия команды
check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

# Определение пакетного менеджера
detect_package_manager() {
    if check_command "dnf"; then
        echo "dnf"
    elif check_command "apt"; then
        echo "apt"
    elif check_command "pacman"; then
        echo "pacman"
    elif check_command "brew"; then
        echo "brew"
    else
        echo "unknown"
    fi
}

# Установка пакетов в зависимости от пакетного менеджера
install_packages() {
    local pm=$1
    print_message "Установка необходимых пакетов..."
    
    case $pm in
        "dnf")
            sudo dnf install -y stow git vim tmux thefuck
            ;;
        "apt")
            sudo apt update
            sudo apt install -y stow git vim tmux
            ;;
        "pacman")
            sudo pacman -S --noconfirm stow git vim tmux
            ;;
        "brew")
            brew install stow git vim tmux
            ;;
        *)
            print_error "Неизвестный пакетный менеджер"
            exit 1
            ;;
    esac
}

# Установка vim-plug
install_vim_plug() {
    print_message "Установка vim-plug..."
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        print_message "vim-plug установлен успешно"
    else
        print_message "vim-plug уже установлен"
    fi
}

# Установка tmux plugin manager
install_tpm() {
    print_message "Установка tmux plugin manager..."
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_message "tmux plugin manager установлен успешно"
    else
        print_message "tmux plugin manager уже установлен"
    fi
}

# Проверка и установка GNU Stow
install_stow() {
    local pm=$(detect_package_manager)
    
    if ! check_command "stow"; then
        print_warning "GNU Stow не установлен"
        install_packages "$pm"
    else
        print_message "GNU Stow уже установлен"
    fi
}

# Основная функция установки
main() {
    print_message "Начало установки dotfiles..."
    
    # Проверка и установка Stow
    install_stow
    
    # Установка менеджеров плагинов
    install_vim_plug
    install_tpm
    
    # Переход в директорию со скриптом
    cd "$(dirname "$0")" || exit 1
    
    # Установка dotfiles с помощью stow
    print_message "Установка конфигурационных файлов..."
    stow -v -t "$HOME" .
    
    print_message "Установка завершена успешно!"
    print_message "Для установки плагинов tmux выполните: tmux new-session 'prefix + I'"
    print_message "Для установки плагинов vim выполните: vim +PlugInstall"
}

# Запуск скрипта
main
