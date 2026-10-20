{ config, lib, pkgs, ... }:

{
imports = [
./bundles/apps/opensource-apps.nix
./bundles/apps/proprietary-apps.nix
./bundles/environments/niri.nix
./bundles/environments/sway.nix
./bundles/shells/minimalshell.nix
./bundles/utilities/desktoputils.nix
./bundles/utilities/fonts.nix
./bundles/utilities/neovim.nix
./home/homemanager.nix
];

options.my.users.mateus = {
enable = lib.mkEnableOption "Habilitar configurações e bundles de usuário";
};

config = lib.mkIf config.my.users.mateus.enable {

users.users.mateus = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
};

my = {
opensource-apps.enable = true;
proprietary-apps.enable = true;

niri.enable = true;
sway.enable = false;

minimalshell = {
enable = true;
user = "mateus";
wallpaper = "/home/mateus/Imagens/wallpaper";
swayidle.timeout = 600;
};

desktoputils.enable = true;
fonts.enable = true;
neovim.enable = true;

homemanager = {
enable = true;
homeDir = "/home/mateus";
owner = "mateus:users";
};
};
};
}
