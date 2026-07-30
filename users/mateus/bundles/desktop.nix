{ config, lib, pkgs, ... }:

{
options.my.desktop.enable = lib.mkEnableOption "Bundle de ferramentas gerais para desktop";

config = lib.mkIf config.my.desktop.enable {

xdg.portal.enable = true;
environment.defaultPackages = lib.mkForce [];

fonts.packages = with pkgs; [
nerd-fonts.jetbrains-mono
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
};
};
}
