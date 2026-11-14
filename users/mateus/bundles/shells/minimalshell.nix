{ config, lib, pkgs, utils, ... }:

let
cfg = config.my.minimalshell;

minimalshellPackages = with pkgs; [
adwaita-icon-theme
bc
cliphist
foot
gammastep
libnotify
mako
mpv
playerctl
swaybg
swayidle
swaylock
waybar
wl-clipboard
];

commonHardening = {
NoNewPrivileges = true;
RestrictSUIDSGID = true;
UMask = "0077";
};

localSocketHardening = commonHardening // {
RestrictAddressFamilies = [
"AF_UNIX"
];
};

lockCommand = lib.escapeShellArgs ["${pkgs.swaylock}/bin/swaylock" "-f"];

powerOffCommand =
if cfg.compositor == "niri" then
lib.escapeShellArgs ["${pkgs.niri}/bin/niri" "msg" "action" "power-off-monitors"]
else
lib.escapeShellArgs ["${pkgs.sway}/bin/swaymsg" "output * power off"];

powerOnCommand =
if cfg.compositor == "niri" then
lib.escapeShellArgs ["${pkgs.niri}/bin/niri" "msg" "action" "power-on-monitors"]
else
lib.escapeShellArgs ["${pkgs.sway}/bin/swaymsg" "output * power on"];

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

compositor = lib.mkOption {
type = lib.types.enum [ "sway" "niri" ];
default = "niri";
description = "Compositor utilizado pela sessão.";
};

swayidle.timeout = lib.mkOption {
type = lib.types.ints.positive;
default = 600;
description = "Tempo de inatividade, em segundos, antes do bloqueio.";
};

swayidle.screenTimeout = lib.mkOption {
type = lib.types.ints.positive;
default = 610;
description = "Tempo de inatividade, em segundos, antes de desligar a tela.";
};
};

config = lib.mkIf cfg.enable {
assertions = [
{
assertion = cfg.swayidle.screenTimeout > cfg.swayidle.timeout;
message = ''O valor de screenTimeout deve ser maior que o valor de timeout. A tela deve ser desligada somente depois do bloqueio.'';
}
];

users.users.${cfg.user}.packages = minimalshellPackages;

fonts.packages = with pkgs; [
nerd-fonts.symbols-only
];

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
ExecStart = utils.escapeSystemdExecArgs ["${pkgs.wl-clipboard}/bin/wl-paste" "--watch" "${pkgs.cliphist}/bin/cliphist" "-max-items" "100" "store"];
Restart = "on-failure";
} // localSocketHardening;
};

mako = {
description = "Mako service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = "${pkgs.mako}/bin/mako";
Restart = "on-failure";
} // localSocketHardening;
};

swaybg = {
description = "Swaybg service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = utils.escapeSystemdExecArgs ["${pkgs.swaybg}/bin/swaybg" "-i" cfg.wallpaper "-m" "fill"];
Restart = "on-failure";
} // localSocketHardening;
};

swayidle = {
description = "Swayidle service";
partOf = [ "minimalshell.target" ];
after = [ "graphical-session.target" ];

unitConfig.ConditionUser = cfg.user;

serviceConfig = {
ExecStart = utils.escapeSystemdExecArgs ["${pkgs.swayidle}/bin/swayidle" "-w" "timeout" (toString cfg.swayidle.timeout) lockCommand "timeout" (toString cfg.swayidle.screenTimeout) powerOffCommand "resume" powerOnCommand "before-sleep" lockCommand];
Restart = "on-failure";
UMask = "0077";
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
NoNewPrivileges = true;
RestrictSUIDSGID = true;
UMask = "0077";
};
};
};
};
}
