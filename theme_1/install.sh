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

if [ -f "$HOME/.zshrc" ]; then
    echo ".zshrc ya existe."
	sleep 0.1
else
    echo "No se encontró .zshrc. Descargandolo..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Descargando plugins"
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

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

if command -v waybar >/dev/null 2>&1; then
    echo "waybar ya está instalado"
else
    echo "waybar NO está instalado"
    sudo pacman -S waybar --noconfirm
fi
if command -v thunar >/dev/null 2>&1; then
    echo "thunar ya está descargado"
else
    echo "thunar No esta instalado..."
    echo "Instalando..."
    sudo pacman -S thunar --noconfirm
fi
if command -v wofi >/dev/null 2>&1; then
    echo "wofi ya está instalado"
else
    echo "wofi no esta instalado"
    sleep 0.2
    echo "descagando wofi..."
    sudo pacman -S wofi --noconfirm
fi
echo -e "${GREEN}Primer paso terminado :D..."
sleep 1
echo -e "Comenzando con la configuración${RESET}"

DIRH="$HOME/.config/hypr"
DIRW="$HOME/.config/waybar"
DIRWP="$HOME/.config/CACA"
DIRBACKUP="$HOME/.config/backups"

# Detectar Hypr
if [ -d "$DIRH" ]; then
    if [ "$(ls -A "$DIRH")" ]; then
        echo "El directorio $DIRH NO está vacío."
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "Desearias hacer copia de seguridad de tus archivos en la carpeta $DIRH que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $DIRH $DIRBACKUP
                    echo "Copia realizada =D"
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $DIRH
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rf $DIRH
                    cp -r -d $DIRH $DIRBACKUP
                    echo "Copiado..."
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $DIRH
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done

    else
        echo "El directorio $DIRH está vacío."
    fi
else
    echo "No existe"
fi


# Detectar waybar
