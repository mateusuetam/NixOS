{ config, lib, pkgs, ... }:

{
imports = [
./hardware-configuration.nix
../users/mateus/settings/course.nix
];

boot = {
loader = {
systemd-boot.enable = true;
efi.canTouchEfiVariables = true;
timeout = 1;
};
kernelPackages = pkgs.linuxPackages_latest;
kernelParams = [
"nowatchdog"
"nmi_watchdog=0"
];
blacklistedKernelModules = [
"thunderbolt"
"ahci" "libahci"
"joydev" "mousedev"
"sp5100_tco" "iTCO_wdt" "iTCO_vendor_support" "watchdog"
"ax25" "netrom" "rose" "adfs" "affs" "befs" "cramfs" "efs" "freevxfs"
"hfs" "hfsplus" "hpfs" "jfs" "minix" "nilfs2" "omfs" "qnx4" "qnx6" "sysv" "vivid"
];
kernel.sysctl = {
"net.ipv4.conf.all.accept_redirects" = 0;
"net.ipv6.conf.all.accept_redirects" = 0;
"net.ipv4.conf.default.accept_redirects" = 0;
"net.ipv6.conf.default.accept_redirects" = 0;
"net.ipv4.conf.all.accept_source_route" = 0;
"net.ipv6.conf.all.accept_source_route" = 0;
"net.ipv4.conf.default.accept_source_route" = 0;
"net.ipv6.conf.default.accept_source_route" = 0;
"net.ipv4.conf.all.send_redirects" = 0;
"net.ipv4.conf.default.send_redirects" = 0;
"net.ipv4.tcp_syncookies" = 1;
"net.ipv4.tcp_rfc1337" = 1;
"net.ipv4.icmp_echo_ignore_all" = 1;
"kernel.dmesg_restrict" = 1;
"kernel.kptr_restrict" = 2;
};
};

networking = {
hostName = "pc";
nftables.enable = true;
firewall.enable = true;
networkmanager.enable = true;
modemmanager.enable = false;
};

systemd.services.NetworkManager-wait-online.enable = false;

console = {
keyMap = "br-abnt2";
};
i18n = {
defaultLocale = "pt_BR.UTF-8";
};
time.timeZone = "America/Recife";

nix = {
settings = {
auto-optimise-store = true;
experimental-features = [
"nix-command"
"flakes"
];
};
gc = {
automatic = true;
dates = "weekly";
options = "--delete-older-than 7d";
};
};

hardware = {
bluetooth.enable = true;
cpu.amd.updateMicrocode = true;
};

security.rtkit.enable = true;

services = {
pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
};
upower = {
enable = true;
percentageLow = 20;
percentageCritical = 15;
percentageAction = 10;
criticalPowerAction = "Suspend";
allowRiskyCriticalPowerAction = true;
};
displayManager.enable = false;
};

xdg.portal.enable = true;

fonts.packages = with pkgs; [
noto-fonts
noto-fonts-cjk-sans
noto-fonts-color-emoji
];

nixpkgs.config.allowUnfree = true;
programs.niri.enable = true;
my.course.enable = true;

users = {
users.mateus = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
};
};

home-manager = {
useGlobalPkgs = true;
useUserPackages = true;
backupFileExtension = "backup";
users = {
mateus = ../users/mateus/user.nix;
};
};

documentation = {
man.enable = true;
info.enable = false;
doc.enable = false;
nixos.enable = false;
};

system.stateVersion = "26.05";
}
