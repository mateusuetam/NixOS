{ config, lib, pkgs, ... }:

{
options.my.neovim.enable =
lib.mkEnableOption "Bundle do Neovim";

config = lib.mkIf config.my.neovim.enable {

programs.neovim = {
enable = true;
defaultEditor = true;

configure = {
customRC = ''
lua << EOF
${builtins.readFile ../../home/.config/nvim/init.lua}
EOF
'';

packages.myVimPackage = with pkgs.vimPlugins; {
start = [
alpha-nvim
];
opt = [
plenary-nvim
telescope-nvim
];
};
};
};
};
}
