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
{ device = "/dev/disk/by-uuid/46d9a9a6-d577-4265-a1a0-44726f1efc91";
fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/89A0-7C59";
fsType = "vfat";
options = [ "fmask=0077" "dmask=0077" ];
};

swapDevices = [ ];

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
