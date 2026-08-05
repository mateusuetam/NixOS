{ config, lib, pkgs, ... }:

{
imports = [
./bundles
./home
];

options.my.users.mateus = {
enable = lib.mkEnableOption "Habilitar minhas configurações de usuário";
};

config = lib.mkIf config.my.users.mateus.enable {

users.users.mateus = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
};

my = {
gnome.enable = true;
niri.enable = false;
sway.enable = false;

quickshell.enable = false;
quickshelldev.enable = false;
shellminimal.enable = false;

browser.enable = true;
course.enable = true;
fonts.enable = true;
neovim.enable = false;
tools.enable = true;

homemanager = {
enable = true;
homeDir = "/home/mateus";
owner = "mateus:users";
};
};
};
}
