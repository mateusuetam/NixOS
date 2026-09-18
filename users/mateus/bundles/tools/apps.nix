{ config, lib, pkgs, ... }:

{
options.my.apps.enable = lib.mkEnableOption "Bundle de ferramentas";

config = lib.mkIf config.my.apps.enable {

services.logmein-hamachi.enable = false;

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"discord"
"discord-unwrapped"
"logmein-hamachi"
"spotify"
"steam"
"steam-unwrapped"
"vscode"
];

programs = {
steam.enable = true;
};

users.users.mateus.packages = with pkgs; [
discord
gimp
logmein-hamachi
mpv
prismlauncher
spotify
vscode
];
};
}
