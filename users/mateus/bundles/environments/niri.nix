{ config, lib, pkgs, ... }:

{
options.my.niri.enable = lib.mkEnableOption "Bundle de ambiente desktop Niri";

config = lib.mkIf config.my.niri.enable {

programs.niri.enable = true;
services.displayManager.enable = false;

users.users.mateus.packages = with pkgs; [
adwaita-icon-theme
alacritty
bc
mpv
xwayland-satellite
];
};
}
