{ config, lib, pkgs, ... }:

{
options.my.minimalshell.enable = lib.mkEnableOption "Bundle para ambiente de trabalho minimalista";

config = lib.mkIf config.my.minimalshell.enable {

users.users.mateus.packages = with pkgs; [
cliphist
foot
gammastep
libnotify
mako
playerctl
swaybg
swayidle
swaylock
waybar
wl-clipboard
];

systemd.user.targets.minimalshell = {
description = "Serviços para ambiente de trabalho minimalista";
wantedBy = [ "graphical-session.target" ];
wants = [
"cliphist.service"
"mako.service"
"swaybg.service"
"swayidle.service"
"waybar.service"
];
partOf = [ "graphical-session.target" ];
};

systemd.user.services = {

cliphist = {
description = "Cliphist service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];
serviceConfig = {
ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
Restart = "on-failure";
};
};

mako = {
description = "Mako service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];
serviceConfig = {
ExecStart = "${pkgs.mako}/bin/mako";
Restart = "on-failure";
};
};

swaybg = {
description = "Swaybg service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];
serviceConfig = {
ExecStart = "${pkgs.swaybg}/bin/swaybg -i /home/mateus/Imagens/FullMoonCastle.png -m fill";
Restart = "on-failure";
};
};

swayidle = {
description = "Swayidle service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];
serviceConfig = {
ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 600 '${pkgs.swaylock}/bin/swaylock -f' before-sleep '${pkgs.swaylock}/bin/swaylock -f'";
Restart = "on-failure";
};
};

waybar = {
description = "Waybar service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];
path = with pkgs; [
bash
bluez
cliphist
foot
gammastep
less
libnotify
networkmanager
procps
util-linux
wireplumber
];
serviceConfig = {
ExecStart = "${pkgs.waybar}/bin/waybar";
Restart = "on-failure";
};
};
};
};
}
