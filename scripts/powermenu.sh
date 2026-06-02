#!/bin/bash
sair=" Sair"
bloquear=" Bloquear"
suspender=" Suspender"
reiniciar=" Reiniciar"
desligar=" Desligar"
options="$sair\n$bloquear\n$suspender\n$reiniciar\n$desligar"
chosen=$(echo -e "$options" | rofi -dmenu -i -theme $HOME/Documentos/repos/configs/rofi/powermenu.rasi)
case $chosen in
$sair)
niri msg action quit --skip-confirmation ;;
$bloquear)
quickshell ipc call lock_manager lock ;;
$suspender)
systemctl suspend ;;
$reiniciar)
reboot ;;
$desligar)
shutdown -h 0 ;;
esac
