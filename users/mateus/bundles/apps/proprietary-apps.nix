{ config, lib, pkgs, ... }:

{
options.my.proprietary-apps.enable = lib.mkEnableOption "Bundle de aplicativos proprietários";

config = lib.mkIf config.my.proprietary-apps.enable {

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"spotify"
"steam"
"steam-unwrapped"
];

programs = {
steam.enable = true;
};

users.users.mateus.packages = with pkgs; [
spotify
];
};
}
