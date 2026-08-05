#!/usr/bin/env bash
sair=" Sair"
bloquear=" Bloquear"
suspender=" Suspender"
reiniciar=" Reiniciar"
desligar=" Desligar"
options="$sair\n$bloquear\n$suspender\n$reiniciar\n$desligar"
chosen=$(echo -e "$options" | rofi -dmenu -i -theme $HOME/.config/rofi/powermenu.rasi)
case $chosen in
$sair)
if [ -n "$SWAYSOCK" ]; then
swaymsg exit
elif [ -n "$NIRI_SOCKET" ]; then
niri msg action quit --skip-confirmation
fi
;;
$bloquear)
swaylock ;;
$suspender)
systemctl suspend ;;
$reiniciar)
reboot ;;
$desligar)
shutdown -h 0 ;;
esac
