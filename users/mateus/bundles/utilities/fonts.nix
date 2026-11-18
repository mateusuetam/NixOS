{ config, lib, pkgs, ... }:

{
options.my.fonts.enable = lib.mkEnableOption "Bundle de fontes";

config = lib.mkIf config.my.fonts.enable {

environment.pathsToLink = [
"/share/fonts"
];

users.users.mateus.packages = with pkgs; [
noto-fonts
noto-fonts-cjk-sans
noto-fonts-color-emoji
nerd-fonts.symbols-only
];
};
}
