{ config, lib, pkgs, ... }:

{
options.my.desktop = {
opensource.enable = lib.mkEnableOption "Bundle de ambiente desktop opensource";
proprietary.enable = lib.mkEnableOption "Bundle de ambiente desktop proprietário";
};

config = lib.mkMerge [

(lib.mkIf config.my.desktop.opensource.enable {

xdg.portal.enable = true;

environment.defaultPackages = lib.mkForce [];

fonts.packages = with pkgs; [
noto-fonts
noto-fonts-cjk-sans
noto-fonts-color-emoji
];

programs = {
bash = {
enable = true;
interactiveShellInit = ''
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
'';
};
git.enable = true;
niri.enable = true;
};

users.users.mateus.packages = with pkgs; [
alacritty
bc
bibata-cursors
gimp
mpv
tree
unzip
xwayland-satellite
zip
];
})

(lib.mkIf config.my.desktop.proprietary.enable {

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"spotify"
];

users.users.mateus.packages = with pkgs; [
spotify
];
})

];
}
