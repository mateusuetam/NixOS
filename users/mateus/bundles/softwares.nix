{ config, lib, pkgs, ... }:

{
options.my.softwares = {
opensource.enable = lib.mkEnableOption "Bundle de softwares opensource";
proprietary.enable = lib.mkEnableOption "Bundle de softwares proprietários";
};

config = lib.mkMerge [

(lib.mkIf config.my.softwares.opensource.enable {

users.users.mateus.packages = with pkgs; [
gimp
mpv
tree
unzip
zip
];
})

(lib.mkIf config.my.softwares.proprietary.enable {

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"discord"
"spotify"
];

users.users.mateus.packages = with pkgs; [
discord
spotify
];
})
];
}
