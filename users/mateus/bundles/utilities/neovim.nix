{ config, lib, pkgs, ... }:

let
mateusNeovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
configure = {
customRC = ''
lua << EOF
${builtins.readFile ../../home/.config/nvim/init.lua}
EOF
'';

packages.myVimPackage = with pkgs.vimPlugins; {
opt = [
plenary-nvim
telescope-nvim
];
};
};
};

in
{
options.my.neovim.enable = lib.mkEnableOption "Bundle do Neovim";

config = lib.mkIf config.my.neovim.enable {
users.users.mateus.packages = [ mateusNeovim ];
};
}
