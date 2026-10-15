{ config, lib, pkgs, ... }:

let
cfg = config.my.minimalshell;

minimalshellPackages = with pkgs; [
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

in
{
options.my.minimalshell = {
enable = lib.mkEnableOption "Bundle para ambiente de trabalho minimalista";

user = lib.mkOption {
type = lib.types.str;
description = "Usuário NixOS ao qual o MinimalShell pertence.";
example = "user";
};

wallpaper = lib.mkOption {
type = lib.types.str;
description = "Caminho da imagem usada pelo swaybg.";
example = "/home/user/Imagens/Wallpaper.png";
};

swayidle.timeout = lib.mkOption {
type = lib.types.ints.positive;
default = 600;
description = "Tempo de inatividade, em segundos, antes do bloqueio.";
};
};

config = lib.mkIf cfg.enable {
users.users.${cfg.user}.packages = minimalshellPackages;

systemd.user.targets.minimalshell = {
description = "Serviços para ambiente de trabalho minimalista";

wantedBy = [ "graphical-session.target" ];
wants = [ "cliphist.service" "mako.service" "swaybg.service" "swayidle.service" "waybar.service" ];
partOf = [ "graphical-session.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;
};

systemd.user.services = {

cliphist = {
description = "Cliphist service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
Restart = "on-failure";
};
};

mako = {
description = "Mako service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.mako}/bin/mako";
Restart = "on-failure";
};
};

swaybg = {
description = "Swaybg service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${cfg.wallpaper} -m fill";
Restart = "on-failure";
};
};

swayidle = {
description = "Swayidle service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout ${toString cfg.swayidle.timeout} '${pkgs.swaylock}/bin/swaylock -f' before-sleep '${pkgs.swaylock}/bin/swaylock -f'";
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

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.waybar}/bin/waybar";
Restart = "on-failure";
};
};
};
};
}
