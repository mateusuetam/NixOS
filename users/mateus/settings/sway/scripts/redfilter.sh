#!/usr/bin/env bash

MENU_THEME="$HOME/Repos/NixOS/users/mateus/settings/sway/rofi/menu.rasi"
INPUT_THEME="$HOME/Repos/NixOS/users/mateus/settings/sway/rofi/input.rasi"
MIN_TEMP=1000
MAX_TEMP=25000
DEFAULT_TEMP=2500

if pgrep -f "gammastep" > /dev/null; then
STATUS="󰅙 Desativar Filtro"
else
STATUS="󰄬 Ativar Filtro (Padrão 2500k)"
fi

OPTIONS="$STATUS\n󱩌 Definir Temperatura Customizada"
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -theme "$MENU_THEME" -p "Filtro de Luz Azul")

case "$CHOICE" in
*"Ativar"*)
gammastep -O $DEFAULT_TEMP &
;;
*"Desativar"*)
pkill -f gammastep
;;
*"Definir Temperatura"*)
TEMP=$(rofi -dmenu -theme "$INPUT_THEME" -p "Digite a temperatura ($MIN_TEMP - $MAX_TEMP):")
if [[ "$TEMP" =~ ^[0-9]+$ ]]; then
if [ "$TEMP" -ge "$MIN_TEMP" ] && [ "$TEMP" -le "$MAX_TEMP" ]; then
pkill -f gammastep
gammastep -O "$TEMP" &
notify-send "Gammastep" "Temperatura da cor ajustada para ${TEMP}K" -i display
else
notify-send "Erro" "Valor fora do escopo! ($MIN_TEMP - $MAX_TEMP)" -u critical
fi
else
[[ -n "$TEMP" ]] && notify-send "Erro" "Insira apenas números!" -u critical
fi
;;
esac
