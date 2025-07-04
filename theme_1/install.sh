#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"
set -e
##############
# Inicio
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
############
# Nerd Fonts
mkdir -p ~/.local/share/fonts && \
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts && \
cd /tmp/nerd-fonts && \
git sparse-checkout init --cone && \
git sparse-checkout set patched-fonts/JetBrainsMono && \
./install.sh JetBrainsMono && \
cd ~ && \
rm -rdvf /tmp/nerd-fonts && \
fc-cache -fv && \
echo "Nerd Fonts añadidos."
###################
# Detectar/Instalar
instalar_si_no_existe() {
    local paquete=$1
    if command -v "$paquete" >/dev/null 2>&1; then
        echo "$paquete ya está instalado"
    else
        echo -e "${RED}$paquete no está instalado${RESET}"
        sleep 0.2
        echo "Instalando $paquete..."
        sudo pacman -S "$paquete" --noconfirm
    fi
}

paquetes=("zsh" "waybar" "kitty" "swww" "firefox" "thunar" "wofi" "fastfetch")
 
for paquete in "${paquetes[@]}"; do
    instalar_si_no_existe "$paquete"
done
################## yay

if command -v yay &> /dev/null
then
    echo "yay ya está instalado"
else
    echo -e "${RED}yay no está instalado${RESET}"

    git clone https://aur.archlinux.org/yay.git /tmp/yay

    cd /tmp/yay || { echo "Error al entrar al directorio yay"; exit 1; }

    makepkg -si --noconfirm

    cd ~
    rm -rf /tmp/yay

fi

if command -v hyprpaper >/dev/null 2>&1; then
    echo "hyprpaper ya esta instalado"
else
    echo "Instalando hyprpaper..."
    yay -S hyprpaper
fi

if command -v waypaper >/dev/null 2>&1; then
    echo "waypaper ya esta instalado"
else
    echo "Instalando waypaper"
    yay -S waypaper
fi

#########
##ZSHRC##
rm -rdvf $HOME/.zshrc
cp $HOME/hyprland_themes/theme_1/.zshrc $HOME
chmod +x $HOME/.zshrc
echo "HECHO"
sleep 1
echo -e "${GREEN}Primer paso terminado :D...${RESET}"
sleep 1
echo -e "${GREEN}Comenzando con la configuración${RESET}"
######################################################
DIRBACKUP="$HOME/.config/backups"
###################################  HYPR
DIRH="$HOME/.config/hypr"
DIRHY="$HOME/hyprland_themes/theme_1/hypr"
if [ -d "$DIRH" ]; then
    if [ "$(ls -A "$DIRH")" ]; then
        echo "El directorio $DIRH NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $DIRH que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $DIRH $DIRBACKUP
                    rm -rdvf $DIRH
                    echo "Copia realizandose =D"
                    cp -dr $DIRHY $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $DIRH
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $DIRH
                    mkdir $DIRH
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
###################################  WAYBAR
DIRW="$HOME/.config/waybar"
DIRWY="$HOME/hyprland_themes/theme_1/waybar"
if [ -d "$DIRW" ]; then
    if [ "$(ls -A "$DIRW")" ]; then
        echo "El directorio $DIRW NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $DIRW que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $DIRW $DIRBACKUP
                    rm -rdvf $DIRW
                    echo "Copia realizandose =D"
                    cp -dr $DIRWY $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $DIRW
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $DIRW
                    mkdir $DIRW
                    cp -dr $DIRWY $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $DIRW
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done
    else
        echo "El directorio $DIRW está vacío."
        echo "Copiando archivos..."
        cp -dr $DIRWY $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $DIRW"
    cp -dr $DIRWY $HOME/.config
fi
###################################  WOFI
WOFI="$HOME/hyprland_themes/theme_1/wofi"
WO="$HOME/.config/wofi"
if [ -d "$WO" ]; then
    if [ "$(ls -A "$WO")" ]; then
        echo "El directorio $WO NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $WO que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $WO $DIRBACKUP
                    rm -rdvf $WO
                    echo "Copia realizandose =D"
                    cp -dr $WOFI $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $WO
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $WO
                    mkdir $WO
                    cp -dr $WOFI $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $WO
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done
    else
        echo "El directorio $WO está vacío."
        echo "Copiando archivos..."
        cp -dr $WOFI $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $WO"
    cp -dr $WOFI $HOME/.config
fi
###################################  KITTY
KI="$HOME/.config/kitty"
TTY="$HOME/hyprland_themes/theme_1/kitty"
if [ -d "$KI" ]; then
    if [ "$(ls -A "$KI")" ]; then
        echo "El directorio $KI NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $KI que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $KI $DIRBACKUP
                    rm -rdvf $KI
                    echo "Copia realizandose =D"
                    cp -dr $TTY $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $KI
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $KI
                    mkdir $KI
                    cp -dr $TTY $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $KI
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done
    else
        echo "El directorio $KI está vacío."
        echo "Copiando archivos..."
        cp -dr $TTY $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $KI"
    cp -dr $TTY $HOME/.config
fi
###################################  FASTFETCH
FAST="$HOME/.config/fastfetch"
FASTFETCH="$HOME/hyprland_themes/theme_1/fastfetch"
if [ -d "$FAST" ]; then
    if [ "$(ls -A "$FAST")" ]; then
        echo "El directorio $FAST NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $FAST que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $FAST $DIRBACKUP
                    rm -rdvf $FAST
                    echo "Copia realizandose =D"
                    cp -dr $FASTFETCH $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $FAST
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $FAST
                    mkdir $FAST
                    cp -dr $FASTFETCH $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $FAST
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done
    else
        echo "El directorio $FAST está vacío."
        echo "Copiando archivos..."
        cp -dr $FASTFETCH $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $FAST"
    cp -dr $FASTFETCH $HOME/.config
fi
###################################  WAYPAPER
WAY="$HOME/.config/waypaper"
WAYPAPER="$HOME/hyprland_themes/theme_1/waypaper"
if [ -d "$WAY" ]; then
    if [ "$(ls -A "$WAY")" ]; then
        echo "El directorio $WAY NO está vacío"
        echo "###########################!!!!!!!!!!!!!"
        echo "###########################!!!!!!!!!!!!!"
        while true; do
            echo -n "¿Desearias hacer copia de seguridad de tus archivos en la carpeta $WAY que va a crear una backup en la carpeta $DIRBACKUP? (y/n) "
            read backup
                if [[ $backup == "y" || $backup == "Y" ]]; then
                    echo "Realizando copia..."
                    cp -r -d $WAY $DIRBACKUP
                    rm -rdvf $WAY
                    echo "Copia realizandose =D"
                    cp -dr $WAYPAPER $HOME/.config
                    echo "Ahora estableceremos permisos de ejecución..."
                    chmod -R +x $WAY
                    sleep 1
                    break
                elif [[ $backup == "n" || $backup == "N" ]]; then
                    echo "Entendido... borrando y copiando los archivos..."
                    rm -rdfv $WAY
                    mkdir $WAY
                    cp -dr $WAYPAPER $HOME/.config
                    echo "Ahora le daremos permisos de ejecución"
                    chmod -R +x $WAY
                    break
                else 
                    echo -e "${RED}Porfavor selecciona una opcion valida${RESET}"
                fi
        done
    else
        echo "El directorio $WAY está vacío."
        echo "Copiando archivos..."
        cp -dr $WAYPAPER $HOME/.config
    fi
else
    echo "Directorio no encontrado"
    echo "Copiando archivos hacia $WAY"
    cp -dr $WAYPAPER $HOME/.config
fi
######################################################
###ohmyzsh###
rm -rdvf ~/.oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
##PLUGINS##
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search \
    ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
######################################################
WALLPAPERS_DIR="$HOME/Wallpapers"
SOURCE_DIR="$HOME/hyprland_themes/theme_1/Wallpapers"
FILE_NAME="l.jpg"

if [ -d "$WALLPAPERS_DIR" ]; then
    if [ ! -f "$WALLPAPERS_DIR/$FILE_NAME" ]; then
        cp "$SOURCE_DIR/$FILE_NAME" "$WALLPAPERS_DIR/"
        echo "Archivo $FILE_NAME copiado a $WALLPAPERS_DIR."
    else
        echo "Archivo $FILE_NAME ya existe en $WALLPAPERS_DIR"
    fi
else
    cp -r "$SOURCE_DIR" "$HOME"
    echo "Carpeta Wallpapers $SOURCE_DIR a $HOME."
fi
###############
hyprctl reload 
chsh -s /usr/bin/zsh

###Reinicio
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
