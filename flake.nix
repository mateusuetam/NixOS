{
description = "Flake de configuração do NixOS";

inputs = {
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
minimalshell.url = "github:mateusuetam/MinimalShell";
myshell.url = "github:mateusuetam/MyShell";
neovim.url = "github:mateusuetam/Neovim";
};

outputs = { nixpkgs, minimalshell, myshell, neovim, ... }: {
nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
system = "x86_64-linux";

modules = [
./configurations/hardware-configuration.nix
./configurations/configuration.nix
minimalshell.nixosModules.minimalshell
myshell.nixosModules.quickshell
neovim.nixosModules.neovim
];
};
};
}
