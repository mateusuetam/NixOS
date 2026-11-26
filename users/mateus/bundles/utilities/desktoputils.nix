{ config, lib, pkgs, ... }:

{
options.my.desktoputils.enable = lib.mkEnableOption "Bundle de ferramentas utilitárias";

config = lib.mkIf config.my.desktoputils.enable {

programs = {
bash.enable = true;
};

users.users.mateus.packages = with pkgs; [
git
less
tree
unzip
zip
];
};
}
