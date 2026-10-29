{ config, lib, pkgs, modulesPath, ... }:

{
imports =
[ (modulesPath + "/installer/scan/not-detected.nix")
];

boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
boot.initrd.kernelModules = [ ];
boot.kernelModules = [ ];
boot.extraModulePackages = [ ];

fileSystems."/" =
{ device = "/dev/disk/by-uuid/b79e4be5-b8ac-458d-9e89-a82b1bc0f52c";
fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/0A11-5B4F";
fsType = "vfat";
options = [ "fmask=0077" "dmask=0077" ];
};

swapDevices = [ ];

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
