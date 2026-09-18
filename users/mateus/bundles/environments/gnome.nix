{ config, lib, pkgs, ... }:

{
options.my.gnome.enable = lib.mkEnableOption "Bundle de ambiente desktop Gnome";

config = lib.mkIf config.my.gnome.enable {

services = {
displayManager.gdm.enable = true;
desktopManager.gnome.enable = true;
};

environment.gnome.excludePackages = with pkgs; [
baobab
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
};
}
