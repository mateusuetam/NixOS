{ config, lib, pkgs, ... }:

{
options.my.environment = {
niri.enable = lib.mkEnableOption "Bundle de ambiente desktop niri";
sway.enable = lib.mkEnableOption "Bundle de ambiente desktop sway";
gnome.enable = lib.mkEnableOption "Bundle de ambiente desktop gnome";
};

config = lib.mkMerge [

# --- Bundle Niri ---

(lib.mkIf config.my.environment.niri.enable {

programs.niri.enable = true;
services.displayManager.enable = false;

users.users.mateus.packages = with pkgs; [
alacritty
bc
bibata-cursors
xwayland-satellite
];
})

# --- Bundle Sway ---

(lib.mkIf config.my.environment.sway.enable {

programs = {
sway = {
enable = true;
extraPackages = [ ];
};
xwayland.enable = true;
};

users.users.mateus.packages = with pkgs; [
alacritty
bc
bibata-cursors
brightnessctl
cliphist
gammastep
grim
libnotify
mako
playerctl
rofi
slurp
swaybg
swayidle
swaylock
waybar
wl-clipboard
];
})

# --- Bundle Gnome ---

(lib.mkIf config.my.environment.gnome.enable {

services = {
displayManager.gdm.enable = true;
desktopManager.gnome.enable = true;
};

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
