{ config, lib, pkgs, ... }:

{
options.my.quickshell = {
shell.enable = lib.mkEnableOption "Enable Quickshell UI";
devmode.enable = lib.mkEnableOption "Ferramentas de Desenvolvimento para a Quickshell";
};

config = lib.mkMerge [

(lib.mkIf config.my.quickshell.shell.enable {

fonts.packages = with pkgs; [
monaspace
];

environment.systemPackages = with pkgs; [
brightnessctl
cliphist
gammastep
libnotify
quickshell
wl-clipboard
];

systemd.user.services.cliphist-watch = {
description = "Clipboard";
partOf = [ "graphical-session.target" ];
wantedBy = [ "graphical-session.target" ];
after = [ "graphical-session.target" ];

serviceConfig = {
ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
Restart = "always";
RestartSec = "3s";
};
};

systemd.user.services.quickshell = {
description = "Quickshell Wayland UI";
partOf = [ "graphical-session.target" ];
after = [ "graphical-session.target" ];
wantedBy = [ "graphical-session.target" ];

path = with pkgs; [
bash
procps
util-linux
cliphist
gammastep
brightnessctl
libnotify
bluez
psmisc
coreutils
systemd
wl-clipboard
"/run/current-system/sw"
"/etc/profiles/per-user/%u"
];

environment = {
QT_LOGGING_RULES = "quickshell.dbus.properties=false;qt.qpa.services=false";
};

serviceConfig = {
ExecStart = "${pkgs.quickshell}/bin/quickshell";
Restart = "on-failure";
KillMode = "process";
};
};
})

(lib.mkIf config.my.quickshell.devmode.enable {

environment.systemPackages = with pkgs; [
qt6.qtwayland

(symlinkJoin {
name = "qmllint-wrapped";
paths = [ qt6.qtdeclarative ];
nativeBuildInputs = [ makeWrapper ];
postBuild = ''
wrapProgram $out/bin/qmllint \
--add-flags "-I ${pkgs.qt6.qtdeclarative}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.qt6.qtbase}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.quickshell}/lib/qt-6/qml"
'';
})
];
})

];
}
