{ config, lib, pkgs, ... }:

{
options.my.desktoputils.enable = lib.mkEnableOption "Bundle de ferramentas utilitárias";

config = lib.mkIf config.my.desktoputils.enable {

xdg.portal.enable = true;

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

users.users.mateus.packages = with pkgs; [
adwaita-icon-theme
bc
less
tree
unzip
zip
];
};
}
