{ config, lib, pkgs, ... }:

{
imports = [
./bundles/apps/opensource-apps.nix
./bundles/apps/proprietary-apps.nix
./bundles/environment/niri.nix
./bundles/environment/sway.nix
./bundles/utilities/desktoputils.nix
./bundles/utilities/fonts.nix
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

niri.enable = false;
quickshell = {
enable = false;
user = "mateus";
dev.enable = false;
};

sway.enable = true;
minimalshell = {
enable = true;
user = "mateus";
wallpaper = "/home/mateus/Imagens/TheWalk.png";
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
