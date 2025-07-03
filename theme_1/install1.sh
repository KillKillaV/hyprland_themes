#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"
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
rm -rf /tmp/nerd-fonts && \
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

paquetes=("zsh" "waybar" "kitty" "swww" "firefox" "thunar" "wofi" "waypaper")
 
for paquete in "${paquetes[@]}"; do
    instalar_si_no_existe "$paquete"
done
###################
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-My-Zsh ya está instalado"
else
    echo "Oh-My-Zsh no encontrado. Instalando..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "Oh-My-Zsh ha sido instalado"
fi
#########
##ZSHRC##
rm $HOME/.zshrc
cp $HOME/hyprland_themes/theme_1/.zshrc $HOME
chmod +x $HOME/.zshrc
echo "HECHO"
sleep 1
echo -e "${GREEN}Primer paso terminado :D...${RESET}"
sleep 1
echo -e "Comenzando con la configuración${RESET}"
######################################################
ORIG="$HOME/hyprland_themes/theme_1/Wallpapers/l.jpg"
DESTD="$HOME/Imágenes/Wallpapers"
DESTI="$DESTD/l.jpg"

mkdir -p "$DESTD"

if [ ! -f "$DESTI" ]; then
    echo "Copiando imagen a $DESTD..."
    cp "$ORIG" "$DESTI"
else
    echo "La imagen ya existe en $DESTD"
fi

gestionar_config "Hyprland" "$DIRH" "$DIRHY" "$DIRBACKUP"
gestionar_config "Waybar" "$DIRW" "$DIRWY" "$DIRBACKUP"
gestionar_config "Wofi" "$WOFI" "$DIRWOFI" "$DIRBACKUP"
gestionar_config "Waypaper" "$WAY" "$WAYPAPER" "$DIRBACKUP"
gestionar_config "Fastfetch" "$FAST" "$FASTFETCH" "$DIRBACKUP"
gestionar_config "Kitty" "$KI" "$TTY" "$DIRBACKUP"

gestionar_config() {
    local nombre="$1"
    local destino="$2"
    local fuente="$3"
    local backupdir="$4"

    echo "### Configuración para $nombre ###"

    if [ -d "$destino" ]; then
        if [ "$(ls -A "$destino")" ]; then
            echo "El directorio $destino NO está vacío."
            while true; do
                read -p "¿Hacer backup de $nombre en $backupdir? (y/n): " backup
                case "$backup" in
                    [yY]) 
                        echo "Realizando copia..."
                        mkdir -p "$backupdir"
                        cp -r "$destino" "$backupdir"
                        break
                        ;;
                    [nN]) 
                        echo "Saltando backup..."
                        break
                        ;;
                    *) echo "Por favor elige y/n" ;;
                esac
            done
            echo "Eliminando $destino"
            rm -rf "$destino"
        else
            echo "$destino existe pero está vacío."
        fi
    else
        echo "$destino no existe. Será creado."
    fi

    echo "Copiando nueva configuración desde $fuente"
    cp -r "$fuente" "$destino"
    chmod -R +x "$destino"
    
    echo "Verificando resultado..."
    sleep 1
    if [ -d "$destino" ] && [ "$(ls -A "$destino")" ]; then
        echo -e "${GREEN}✔ $nombre configurado correctamente en $destino${RESET}"
    else
        echo -e "${RED}✖ Error al configurar $nombre${RESET}"
        exit 1
    fi
}

###ohmyzsh###
rm -rf ~/.oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
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