{ config, lib, pkgs, ... }:

{
options.my.shellminimal.enable = lib.mkEnableOption "Bundle para ambientes minimalistas";

config = lib.mkIf config.my.shellminimal.enable {

users.users.mateus.packages = with pkgs; [
brightnessctl
cliphist
gammastep
libnotify
mako
playerctl
rofi
swaybg
swayidle
swaylock
waybar
wl-clipboard
];
};
}
