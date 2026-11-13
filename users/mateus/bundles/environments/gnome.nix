{ config, lib, pkgs, ... }:

{
options.my.gnome.enable = lib.mkEnableOption "Bundle de ambiente desktop Gnome";

config = lib.mkIf config.my.gnome.enable {

services = {
displayManager.gdm.enable = true;
desktopManager.gnome.enable = true;
gnome.core-apps.enable = false;
gnome.core-developer-tools.enable = false;
gnome.games.enable = false;
};

environment.systemPackages = with pkgs; [
decibels
gnome-calculator
gnome-text-editor
gnome-console
loupe
nautilus
papers
showtime
];

environment.gnome.excludePackages = with pkgs; [
gnome-tecla
gnome-tour
gnome-user-docs
];
};
}
