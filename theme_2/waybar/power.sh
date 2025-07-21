#!/bin/bash

chosen=$(wofi --dmenu --prompt="Elegir destino..." --style ~/.config/wofi/style.css <<EOF
󰐥 Apagar
󰜉 Reiniciar
󰤄 Suspender
󰍃 Cerrar sesión
EOF
)

case "$chosen" in
    *Apagar*) systemctl poweroff ;;
    *Reiniciar*) systemctl reboot ;;
    *Suspender*) systemctl suspend ;;
    *Cerrar*) hyprctl dispatch exit ;;
    *) exit 1 ;;
esac

