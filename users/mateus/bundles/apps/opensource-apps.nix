{ config, lib, pkgs, ... }:

{
options.my.opensource-apps.enable = lib.mkEnableOption "Bundle de aplicativos de código aberto";

config = lib.mkIf config.my.opensource-apps.enable {

users.users.mateus.packages = with pkgs; [
firefox
gimp
];
};
}
