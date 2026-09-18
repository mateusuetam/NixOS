{ config, lib, pkgs, ... }:

{
options.my.proprietary-apps.enable = lib.mkEnableOption "Bundle de aplicativos proprietários";

config = lib.mkIf config.my.proprietary-apps.enable {

services.logmein-hamachi.enable = false;

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"discord"
"discord-unwrapped"
"logmein-hamachi"
"spotify"
"steam"
"steam-unwrapped"
];

programs = {
steam.enable = true;
};

users.users.mateus.packages = with pkgs; [
discord
logmein-hamachi
spotify
];
};
}
