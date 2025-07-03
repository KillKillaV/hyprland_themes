#!/bin/bash
set -e

# Colores
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

ask_yes_no() {
    while true; do
        echo -ne "$1 (y/n): "
        read -r ans
        case "$ans" in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            *) echo -e "${RED}Por favor selecciona una opción válida${RESET}" ;;
        esac
    done
}

check_and_install() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}Instalando $1...${RESET}"
        sudo pacman -S --noconfirm "$1"
    else
        echo "$1 ya está instalado"
    fi
}

copy_config_with_backup() {
    local src="$1"
    local dest="$2"
    local backup_dir="$HOME/.config/backups"

    if [ -d "$dest" ] && [ "$(ls -A "$dest")" ]; then
        echo -e "${RED}$dest ya contiene archivos${RESET}"
        if ask_yes_no "¿Deseas hacer una copia de seguridad de $dest en $backup_dir?"; then
            mkdir -p "$backup_dir"
            cp -r "$dest" "$backup_dir"
        fi
        rm -rf "$dest"
    fi
    cp -r "$src" "$dest"
    chmod -R +x "$dest"
}

# Confirmación inicial
if ! ask_yes_no "${RED}Esto inicia la instalación del theme_1. ¿Quieres continuar?"; then
    echo -e "${RED}Instalación cancelada.${RESET}"
    exit 0
fi

echo -e "${GREEN}Iniciando instalación...${RESET}"

# Actualizar sistema
if ask_yes_no "${GREEN}¿Deseas actualizar binarios/sistema?"; then
    sudo pacman -Syu --noconfirm
else
    echo -e "${RED}Actualización omitida${RESET}"
fi

# Instalar yay y herramientas base
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
yay -S --noconfirm fastfetch waypaper hyprpaper

# Nerd Fonts
mkdir -p ~/.local/share/fonts
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts
cd /tmp/nerd-fonts
git sparse-checkout init --cone
git sparse-checkout set patched-fonts/JetBrainsMono
./install.sh JetBrainsMono
cd ~ && rm -rf /tmp/nerd-fonts
fc-cache -fv
echo "Nerd Fonts añadidos."

# Comprobaciones e instalaciones necesarias
for pkg in waybar kitty swww firefox zsh thunar wofi waypaper; do
    check_and_install "$pkg"
done

# Cambiar shell por ZSH
chsh -s "$(which zsh)"

# Copiar imagen de fondo
WALL_SRC="$HOME/hyprland_themes/theme_1/Wallpapers/l.jpg"
WALL_DEST="$HOME/Imágenes/Wallpapers/l.jpg"
mkdir -p "$(dirname "$WALL_DEST")"
[ -f "$WALL_DEST" ] || cp "$WALL_SRC" "$WALL_DEST"

# Instalar Oh-My-Zsh si no está presente
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Instalando Oh-My-Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Copiar .zshrc
cp "$HOME/hyprland_themes/theme_1/.zshrc" "$HOME/.zshrc"
chmod +x "$HOME/.zshrc"

# Configuración general
echo -e "${GREEN}Comenzando configuración de entorno...${RESET}"
declare -A CONFIG_DIRS=(
    ["hypr"]="$HOME/.config/hypr"
    ["waybar"]="$HOME/.config/waybar"
    ["wofi"]="$HOME/.config/wofi"
    ["waypaper"]="$HOME/.config/waypaper"
    ["fastfetch"]="$HOME/.config/fastfetch"
    ["kitty"]="$HOME/.config/kitty"
)

for key in "${!CONFIG_DIRS[@]}"; do
    SRC="$HOME/hyprland_themes/theme_1/$key"
    DEST="${CONFIG_DIRS[$key]}"
    echo -e "${GREEN}Configurando $key...${RESET}"
    copy_config_with_backup "$SRC" "$DEST"
done

# Reiniciar servicios
killall waybar 2>/dev/null || true
waybar &
hyprctl reload

echo -e "${GREEN}Instalación completada con éxito 🎉${RESET}"
