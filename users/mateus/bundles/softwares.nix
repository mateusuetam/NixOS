{ config, lib, pkgs, ... }:

{
options.my.softwares = {
opensource.enable = lib.mkEnableOption "Bundle de softwares opensource";
proprietary.enable = lib.mkEnableOption "Bundle de softwares proprietários";
};

config = lib.mkMerge [

(lib.mkIf config.my.softwares.opensource.enable {

users.users.mateus.packages = with pkgs; [
alacritty
bc
gimp
mpv
];
})

(lib.mkIf config.my.softwares.proprietary.enable {

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"spotify"
"vscode"
];

users.users.mateus.packages = with pkgs; [
spotify
vscode
];
})
];
}
