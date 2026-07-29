{ config, lib, pkgs, ... }:

{
imports = [
./bundles/browser.nix
./bundles/course.nix
./bundles/desktop.nix
./bundles/dotfiles.nix
./bundles/neovim.nix
./bundles/softwares.nix
../../quickshell/shell.nix
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
dotfiles = {
enable = true;
homeDir = "/home/mateus";
owner = "mateus:users";
};

softwares = {
opensource.enable = true;
proprietary.enable = true;
};

desktop = {
general.enable = true;
niri.enable = false;
gnome.enable = true;
};

quickshell = {
shell.enable = false;
devmode.enable = false;
};

browser.enable = true;
neovim.enable = true;

course.enable = true;
};
};
}
