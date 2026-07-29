{ config, lib, pkgs, ... }:

{
options.my.desktop = {
general.enable = lib.mkEnableOption "Bundle de ferramentas gerais para desktop";
niri.enable = lib.mkEnableOption "Bundle de ambiente desktop niri";
gnome.enable = lib.mkEnableOption "Bundle de ambiente desktop gnome";
};

config = lib.mkMerge [

# --- Bundle General ---

(lib.mkIf config.my.desktop.general.enable {

xdg.portal.enable = true;

environment.defaultPackages = lib.mkForce [];

fonts.packages = with pkgs; [
noto-fonts
noto-fonts-cjk-sans
noto-fonts-color-emoji
];

programs = {
bash = {
enable = true;
interactiveShellInit = ''
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
'';
};
git.enable = true;
};
})

# --- Bundle Niri ---

(lib.mkIf config.my.desktop.niri.enable {

programs.niri.enable = true;
services.displayManager.enable = false;

users.users.mateus.packages = with pkgs; [
alacritty
bc
bibata-cursors
xwayland-satellite
];
})

# --- Bundle Gnome ---

(lib.mkIf config.my.desktop.gnome.enable {

services.displayManager.gdm.enable = true;
services.desktopManager.gnome.enable = true;

fonts.packages = with pkgs; [
monaspace
];

environment.gnome.excludePackages = with pkgs; [
baobab
decibels
epiphany
gnome-calendar
gnome-characters
gnome-clocks
gnome-connections
gnome-contacts
gnome-disk-utility
gnome-font-viewer
gnome-logs
gnome-maps
gnome-music
gnome-system-monitor
gnome-tecla
gnome-tour
gnome-user-docs
gnome-weather
seahorse
simple-scan
snapshot
yelp
];
})
];
}
