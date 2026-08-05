#!/usr/bin/env bash
menu() {
rofi -dmenu -theme "$HOME/.config/rofi/menu.rasi" -p "Wi-Fi"
}
clean() {
sed -r 's/\x1B\[[0-9;]*[mK]//g'
}
is_on() {
nmcli radio wifi | grep -q "enabled"
}
toggle_power() {
if is_on; then
nmcli radio wifi off && notify-send "Wi-Fi Desligado"
else
nmcli radio wifi on && notify-send "Wi-Fi Ligado"
sleep 2
fi
}
current_connection() {
nmcli -t -f NAME connection show --active | head -n1
}
list_known() {
nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-11-wireless"{print $1}' | sed '/^$/d'
}
scan_networks() {
nmcli dev wifi rescan >/dev/null 2>&1
sleep 2
nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL dev wifi list | clean | while IFS=: read -r inuse ssid security signal; do
[ -z "$ssid" ] && continue
if [ "$signal" -ge 80 ]; then icon="󰤨"
elif [ "$signal" -ge 60 ]; then icon="󰤥"
elif [ "$signal" -ge 40 ]; then icon="󰤢"
else icon="󰤟"
fi
[ -z "$security" ] && sec="󰌿 Open" || sec="󰌾 $security"
[ "$inuse" = "*" ] && active="󰄬 " || active=""
printf "%s%s %s%% | %s\n" "$active" "$icon $ssid" "$signal" "$sec"
done
}
connect_network() {
ssid="$1"
confirm=$(printf "󰄬 Confirmar conexão\n󰜺 Cancelar" | menu)
[ "$confirm" != "󰄬 Confirmar conexão" ] && return
security=$(nmcli -t -f SSID,SECURITY dev wifi list | grep "^$ssid:" | cut -d: -f2)
if [ -z "$security" ]; then
nmcli dev wifi connect "$ssid" && notify-send "Conectado a $ssid"
else
password=$(rofi -dmenu -theme "$HOME/.config/rofi/input.rasi" -p "Senha para $ssid" -password)
[ -z "$password" ] && return
nmcli dev wifi connect "$ssid" password "$password" && notify-send "Conectado a $ssid"
fi
}
scan_menu() {
while true; do
networks="$(scan_networks)"
choice=$(printf "󰑐 Atualizar scan\n󰜺 Voltar\n%s\n%s" "󰤥 ───── Redes encontradas ───── 󰤥" "$networks" | menu)
case "$choice" in
"󰑐 Atualizar scan") notify-send "Atualizando scan..." && continue ;;
"󰜺 Voltar" | "") return ;;
*)
ssid=$(echo "$choice" | sed -E 's/^.*󰤨 |^.*󰤥 |^.*󰤢 |^.*󰤟 //' | sed 's/ [0-9]\+%.*//')
connect_network "$ssid"
;;
esac
done
}
forget_network() {
nmcli connection delete "$1" && notify-send "Rede $1 removida"
}
saved_menu() {
ssid="$1"
choice=$(printf "󱛃 Conectar\n󱛂 Desconectar\n󱛅 Esquecer\n󰜺 Voltar" | menu)
case "$choice" in
"󱛃 Conectar") nmcli connection up "$ssid" && notify-send "Conectado a $ssid" ;;
"󱛂 Desconectar") nmcli connect down "$ssid" && notify-send "Desconectado de $ssid" ;;
"󱛅 Esquecer") forget_network "$ssid" ;;
esac
}
separator="󰤥 ────────── Redes salvas ────────── 󰤥"
main_menu() {
while true; do
if ! is_on; then
choice=$(printf "󰤮 Ligar Wi-Fi\n󰜺 Sair" | menu)
case "$choice" in
"󰤮 Ligar Wi-Fi") toggle_power ;;
*) exit ;;
esac
continue
fi
current="$(current_connection)"
saved="$(list_known)"
[ -n "$current" ] && saved="$(echo "$saved" | grep -vx "$current")"
options="󰤭 Desligar Wi-Fi
󰤨 Escanear redes
󰜺 Sair
$separator"
[ -n "$current" ] && options="$options
󰤨 Conectado: $current"
[ -n "$saved" ] && options="$options
$saved"
choice=$(printf "%s" "$options" | menu)
case "$choice" in
"󰤭 Desligar Wi-Fi") toggle_power ;;
"󰤨 Escanear redes") notify-send "Realizando scan..." && scan_menu ;;
"󰜺 Sair" | "") exit ;;
"$separator") continue ;;
󰤨\ Conectado:*)
ssid="${choice#󰤨 Conectado: }"
saved_menu "$ssid"
;;
*)
saved_menu "$choice"
;;
esac
done
}
main_menu
