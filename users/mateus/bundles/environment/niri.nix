{ config, lib, pkgs, ... }:

{
options.my.niri.enable = lib.mkEnableOption "Bundle de ambiente desktop Niri";

config = lib.mkIf config.my.niri.enable {

xdg.portal.enable = true;
services.displayManager.enable = false;

programs.niri.enable = true;

users.users.mateus.packages = with pkgs; [
xwayland-satellite
];
};
}
