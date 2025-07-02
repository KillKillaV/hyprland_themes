#!/bin/bash

set -e

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

while true; do
    echo -n -e "${RED}Esto inicia la instalación del theme_1. ¿Quieres continuar? (y/n) "
    read decision
         if [[ "$decision" == "y" || "$decision" == "Y" ]]; then
            echo -e "${GREEN}Iniciando instalacion..."
            sleep 0.1
            break
        elif [[ "$decision" == "n" || "$decision" == "N" ]]; then
            echo -e "${RED}Instalacion cancelada.${RESET}"
            exit 0
        else
            echo "Pofavor selecciona algo, y = yes, n = no..."
        fi
done



set +e
while true; do
        echo -n -e "${GREEN}Deseas actualizar binarios/sistema? (y/n) "
        read actu
        if [[ "$actu" == "y" || "$actu" == "Y" ]]; then
            echo -e "${GREEN}Actualizando..."
            sudo pacman -Syu 2>/dev/null --noconfirm
            break
        elif [[ "$actu" == "n" || "$actu" == "N" ]]; then
            echo -e "${RED}No actualizacion selecionada${RESET}"
            break
        else
            echo "Pofavor selecciona algo, y = yes, n = no..."
        fi
done
# Instalacion yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
sleep 2
yay -S fastfetch

# Añadiendo Nerd Fonts
mkdir -p ~/.local/share/fonts && \
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts && \
cd /tmp/nerd-fonts && \
git sparse-checkout init --cone && \
git sparse-checkout set patched-fonts/JetBrainsMono && \
./install.sh JetBrainsMono && \
cd ~ && \
rm -rf /tmp/nerd-fonts && \
fc-cache -fv && \
echo "Nerd Fonts añadidos."

echo "Descargando plugins"
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

if command -v waybar >/dev/null 2>&1; then
    echo "waybar ya está instalado"
else
    echo "waybar NO está instalado"
    echo "Instalando..."
    sudo pacman -S waybar --noconfirm
fi
if command -v kitty >/dev/null 2>&1; then
    echo "kitty ya esta instalado"
else
    echo "${RED}kitty NO esta instalado${RESET}"
    echo "Instalando..."
    sudo pacman -S kitty --noconfirm
fi
if command -v firefox >/dev/null 2>&1; then
    echo "firefox ya esta instalado :) "
else
    echo "firefox no esta instalado..."
    sleep 1
    while true; do
            echo -n "¿Desearias instalar firefox? (y/n) "
            read firefox
                if [[ $firefox == "y" || $firefox == "Y" ]]; then
                    echo "Entendido, iniciando descarga..."
                    sudo pacman -S firefox
                    break
                elif [[ $firefox == "n" || $firefox == "N" ]]; then
                    echo "Entendido..."
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        
    done
fi
sudo pacman -S zsh
chsh -s $(which zsh)
if command -v thunar >/dev/null 2>&1; then
    echo "thunar ya está descargado"
else
    echo "${RED}thunar NO esta instalado...${RESET}"
    echo "Instalando..."
    sudo pacman -S thunar --noconfirm
fi
if command -v wofi >/dev/null 2>&1; then
    echo "wofi ya está instalado"
else
    echo "${RED}wofi no esta instalado${RESET}"
    sleep 0.2
    echo "Descargando wofi..."
    sudo pacman -S wofi --noconfirm
fi
if command -v waypaper >/dev/null 2>&1; then
    echo "waypaper ya esta instalado"
else
    echo "${RED}waypaper no esta instalado${RESET}"
    sleep 0.2
    echo "Instalando waypaper..."
    sudo pacman -S waypaper --noconfirm
fi
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-My-Zsh ya está instalado"
else
    echo "Oh-My-Zsh no encontrado. Instalando..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "Oh-My-Zsh ha sido instalado"
fi
# Situando .zshrc
rm $HOME/.zshrc
cp $HOME/hyprland_themes/theme_1/.zshrc $HOME
chmod +x $HOME/.zshrc
echo "HECHO"
sleep 1
echo -e "${GREEN}Primer paso terminado :D...${RESET}"
sleep 1
echo -e "Comenzando con la configuración${RESET}"

DIRH="$HOME/.config/hypr"
DIRW="$HOME/.config/waybar"
DIRBACKUP="$HOME/.config/backups"
DIRHY="$HOME/hyprland_themes/theme_1/hypr"
DIRWY="$HOME/hyprland_themes/theme_1/waybar"
DIRWOFI="$HOME/hyprland_themes/theme_1/wofi"
WOFI="$HOME/.config/wofi"
WAY="$HOME/.config/waypaper"
WAYPAPER="$HOME/hyprland_themes/theme_1/waypaper"
FAST="$HOME/.config/fastfetch"
FASTFETCH="$HOME/hyprland_themes/theme_1/fastfetch"
KI="$HOME/.config/kitty"
TTY="$HOME/hyprland_themes/theme_1/kitty"

# Detectar Hypr
if [ -d "$DIRH" ]; then
    if [ "$(ls -A "$DIRH")" ]; then
        echo "El directorio $DIRH NO está vacío."
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $DIRH que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $DIRH $DIRBACKUP
                    rm -rd $DIRH
                    echo "Copia realizandose =D"
                    cp -dr $DIRHY $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $DIRH
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rf $DIRH
                    mkdir ~/.config/hypr
                    cp -dr $DIRHY $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $DIRH
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done

    else
        echo "El directorio $DIRH está vacío."
        echo "Copiando archivos..."
        cp -dr $DIRHY $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $DIRH"
    cp -dr $DIRHY $HOME/.config
fi
hyprctl reload
echo -e "${GREEN}Viendo su los cambios se han efectuado bien${RESET}"
sleep 1 
echo -e "${GREEN}Confirmando${RESET}"
if [ -d "$DIRH" ]; then
    echo -e "Existe el directorio $DIRH!${RESET}"
    if [ "$(ls -A "$DIRH")" ]; then
        echo -e "${GREEN}En el directorio $DIRH hay archivos!!${RESET}"
    else
        echo -e "${RED}No hay archivos en $DIRH :( ${RESET}"
        exit 0
    fi
else
    echo -e "${RED}No existe el directorio ${DIRH}...${RESET}"
    exit 0
fi

# Detectar waybar
if [ -d "$DIRW" ]; then
    if [ "$(ls -A "$DIRW")" ]; then
        echo -e "${GREEN}El directorio $DIRW no está vacío.${RESET}"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Deseas hacer copia de seguridad de los archivos en $DIRW? Se guardarán en $DIRBACKUP (y/n): "
            read backup
            if [[ "$backup" == "y" || "$backup" == "Y" ]]; then
                echo "Realizando copia..."
                mkdir -p "$DIRBACKUP"
                cp -r "$DIRW" "$DIRBACKUP"
                echo "Copia realizada"
            elif [[ "$backup" == "n" || "$backup" == "N" ]]; then
                echo "Saltando copia..."
            else 
                echo -e "${RED}Por favor selecciona una opción válida${RESET}"
                continue
            fi

            echo "Eliminando $DIRW"
            rm -rf "$DIRW"
            echo "Copiando nueva configuración desde $DIRWY"
            cp -r "$DIRWY" "$DIRW"
            echo "Estableciendo permisos de ejecución..."
            chmod -R +x "$DIRW"
            sleep 1
            break
        done
    else
        echo "El directorio $DIRW está vacío."
        echo "Copiando archivos..."
        cp -r "$DIRWY" "$DIRW"
        chmod -R +x "$DIRW"
    fi
else
    echo "Directorio $DIRW no encontrado, creando y copiando archivos..."
    cp -r "$DIRWY" "$DIRW"
    chmod -R +x "$DIRW"
fi

hyprctl reload

echo "Viendo si los cambios se han efectuado correctamente..."
sleep 1

if [ -d "$DIRW" ]; then
    echo -e "${GREEN}Existe el directorio $DIRW!${RESET}"
    if [ "$(ls -A "$DIRW")" ]; then
        echo -e "${GREEN}En el directorio $DIRW hay archivos!${RESET}"
    else
        echo -e "${RED}No hay archivos en $DIRW :(${RESET}"
        exit 1
    fi
else
    echo -e "${RED}No existe el directorio $DIRW...${RESET}"
    exit 1
fi
killall waybar
waybar &
sleep 4
echo "Iniciando configuracion Wofi"

# Wofi
if [ -d "$WOFI" ]; then
    if [ "$(ls -A "$WOFI")" ]; then
        echo -e "${GREEN}El directorio $WOFI no está vacío.${RESET}"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Deseas hacer copia de seguridad de los archivos en $WOFI? Se guardarán en $DIRBACKUP (y/n): "
            read backup
            if [[ "$backup" == "y" || "$backup" == "Y" ]]; then
                echo "Realizando copia..."
                mkdir -p "$DIRBACKUP"
                cp -r "$WOFI" "$DIRBACKUP"
                echo "Copia realizada"
            elif [[ "$backup" == "n" || "$backup" == "N" ]]; then
                echo "Saltando copia..."
            else 
                echo -e "${RED}Por favor selecciona una opción válida${RESET}"
                continue
            fi

            echo "Eliminando $WOFI"
            rm -rf "$WOFI"
            echo "Copiando nueva configuración desde $DIRWOFI"
            cp -r "$DIRWOFI" "$WOFI"
            echo "Estableciendo permisos de ejecución..."
            chmod -R +x "$WOFI"
            sleep 1
            break
        done
    else
        echo "El directorio $WOFI está vacío."
        echo "Copiando archivos..."
        cp -r "$DIRWOFI" "$WOFI"
        chmod -R +x "$WOFI"
    fi
else
    echo "Directorio $WOFI no encontrado, creando y copiando archivos..."
    cp -r "$DIRWOFI" "$WOFI"
    chmod -R +x "$WOFI"
fi

hyprctl reload

echo "Viendo si los cambios se han efectuado correctamente..."
sleep 1

if [ -d "$WOFI" ]; then
    echo -e "${GREEN}Existe el directorio $WOFI!${RESET}"
    if [ "$(ls -A "$WOFI")" ]; then
        echo -e "${GREEN}En el directorio $WOFI hay archivos!${RESET}"
    else
        echo -e "${RED}No hay archivos en $WOFI :(${RESET}"
        exit 1
    fi
else
    echo -e "${RED}No existe el directorio $WOFI...${RESET}"
    exit 1
fi

# Waypaper
if [ -d "$WAY" ]; then
    if [ "$(ls -A "$WAY")" ]; then
        echo -e "${GREEN}El directorio $WAY no está vacío.${RESET}"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Deseas hacer copia de seguridad de los archivos en $WAY? Se guardarán en $DIRBACKUP (y/n): "
            read backup
            if [[ "$backup" == "y" || "$backup" == "Y" ]]; then
                echo "Realizando copia..."
                mkdir -p "$DIRBACKUP"
                cp -r "$WAY" "$DIRBACKUP"
                echo "Copia realizada"
            elif [[ "$backup" == "n" || "$backup" == "N" ]]; then
                echo "Saltando copia..."
            else 
                echo -e "${RED}Por favor selecciona una opción válida${RESET}"
                continue
            fi

            echo "Eliminando $WAY"
            rm -rf "$WAY"
            echo "Copiando nueva configuración desde $WAYPAPER"
            cp -r "$WAYPAPER" "$WAY"
            echo "Estableciendo permisos de ejecución..."
            chmod -R +x "$WAY"
            sleep 1
            break
        done
    else
        echo "El directorio $WAY está vacío."
        echo "Copiando archivos..."
        cp -dr "$WAYPAPER" "$WAY"
        chmod -R +x "$WAY"
    fi
else
    echo "Directorio $WAY no encontrado, creando y copiando archivos..."
    cp -dr "$WAYPAPER" "$WAY"
    chmod -R +x "$WAY"
fi

hyprctl reload

echo "Viendo si los cambios se han efectuado correctamente..."
sleep 1

if [ -d "$WAY" ]; then
    echo -e "${GREEN}Existe el directorio $WAY!${RESET}"
    if [ "$(ls -A "$WAY")" ]; then
        echo -e "${GREEN}En el directorio $WAY hay archivos!${RESET}"
    else
        echo -e "${RED}No hay archivos en $WAY :(${RESET}"
        exit 1
    fi
else
    echo -e "${RED}No existe el directorio $WAY...${RESET}"
    exit 1
fi
# Fastfetch
echo "Descarando fastfetch..."
sleep 2
sudo pacman -S fastfetch --noconfirm
echo "Hecho :)... Ya queda poco"
if [ -d "$FAST" ]; then
    if [ "$(ls -A "$FAST")" ]; then
        echo -e "${GREEN}El directorio $FAST no está vacío.${RESET}"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Deseas hacer copia de seguridad de los archivos en $FAST? Se guardarán en $DIRBACKUP (y/n): "
            read backup
            if [[ "$backup" == "y" || "$backup" == "Y" ]]; then
                echo "Realizando copia..."
                mkdir -p "$DIRBACKUP"
                cp -r "$FAST" "$DIRBACKUP"
                echo "Copia realizada"
            elif [[ "$backup" == "n" || "$backup" == "N" ]]; then
                echo "Saltando copia..."
            else 
                echo -e "${RED}Por favor selecciona una opción válida${RESET}"
                continue
            fi

            echo "Eliminando $FAST"
            rm -rf "$FAST"
            echo "Copiando nueva configuración desde $FASTFETCH"
            cp -r "$FASTFETCH" "$FAST"
            echo "Estableciendo permisos de ejecución..."
            chmod -R +x "$FAST"
            sleep 1
            break
        done
    else
        echo "El directorio $FAST está vacío."
        echo "Copiando archivos..."
        cp -dr "$FASTFETCH" "$FAST"
        chmod -R +x "$FAST"
    fi
else
    echo "Directorio $FAST no encontrado, creando y copiando archivos..."
    cp -dr "$FASTFETCH" "$FAST"
    chmod -R +x "$FAST"
fi

hyprctl reload

echo "Viendo si los cambios se han efectuado correctamente..."
sleep 1

if [ -d "$FAST" ]; then
    echo -e "${GREEN}Existe el directorio $FAST!${RESET}"
    if [ "$(ls -A "$FAST")" ]; then
        echo -e "${GREEN}En el directorio $FAST hay archivos!${RESET}"
    else
        echo -e "${RED}No hay archivos en $FAST :(${RESET}"
        exit 1
    fi
else
    echo -e "${RED}No existe el directorio $FAST...${RESET}"
    exit 1
fi

#KI="$HOME/.config/kitty"
#TTY="$HOME/hyprland_themes/theme_1/kitty

#kitty
if [ -d "$KI" ]; then
    if [ "$(ls -A "$KI")" ]; then
        echo -e "${GREEN}El directorio $KI no está vacío.${RESET}"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Deseas hacer copia de seguridad de los archivos en $KI? Se guardarán en $DIRBACKUP (y/n): "
            read backup
            if [[ "$backup" == "y" || "$backup" == "Y" ]]; then
                echo "Realizando copia..."
                mkdir -p "$DIRBACKUP"
                cp -r "$KI" "$DIRBACKUP"
                echo "Copia realizada"
            elif [[ "$backup" == "n" || "$backup" == "N" ]]; then
                echo "Saltando copia..."
            else 
                echo -e "${RED}Por favor selecciona una opción válida${RESET}"
                continue
            fi

            echo "Eliminando $KI"
            rm -rf "$KI"
            echo "Copiando nueva configuración desde $TTY"
            cp -rd "$TTY" "$KI"
            echo "Estableciendo permisos de ejecución..."
            chmod -R +x "$KI"
            sleep 1
            break
        done
    else
        echo "El directorio $KI está vacío."
        echo "Copiando archivos..."
        cp -dr "$TTY" "$KI"
        chmod -R +x "$KI"
    fi
else
    echo "Directorio $KI no encontrado, creando y copiando archivos..."
    cp -dr "$TTY" "$KI"
    chmod -R +x "$KI"
fi

hyprctl reload

echo "Viendo si los cambios se han efectuado correctamente..."
sleep 1

if [ -d "$KI" ]; then
    echo -e "${GREEN}Existe el directorio $KI!${RESET}"
    if [ "$(ls -A "$KI")" ]; then
        echo -e "${GREEN}En el directorio $KI hay archivos!${RESET}"
    else
        echo -e "${RED}No hay archivos en $KI :(${RESET}"
        exit 1
    fi
else
    echo -e "${RED}No existe el directorio $KI...${RESET}"
    exit 1
fi
plugins=(
	"zsh-autosuggestions"
	"zsh-syntax-highlighting"
	"zsh-history-substring-search"
)
repos=(
	"https://github.com/zsh-users/zsh-autosuggestions"
	"https://github.com/zsh-users/zsh-syntax-highlighting"
	"https://github.com/zsh-users/zsh-history-substring-search"
)

for i in "${!plugins[@]}"; do
    plugin="${plugins[$i]}"
    repo="${repos[$i]}"
    PLUGIN_PATH="$PLUGINS_DIR/$plugin"

    if [ -d "$PLUGIN_PATH" ]; then
        echo "Actualizando $plugin..."
        git -C "$PLUGIN_PATH" pull
    else
        echo "Clonando $plugin..."
        git clone "$repo" "$PLUGIN_PATH"
    fi
done
echo "Hecho, reiniciando en 5"
sleep 1
echo "4"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
sudo reboot now