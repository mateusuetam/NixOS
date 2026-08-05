{ config, lib, pkgs, ... }:

{
options.my.homemanager = {
enable = lib.mkEnableOption "Bundle de gerenciamento de dotfiles";

homeDir = lib.mkOption {
type = lib.types.str;
example = "/home/username";
description = "Diretório HOME onde os dotfiles serão instalados.";
};

owner = lib.mkOption {
type = lib.types.str;
example = "username:users";
description = "Usuário e grupo proprietários dos dotfiles.";
};
};

config = lib.mkIf config.my.homemanager.enable {

system.activationScripts.homemanager = {

deps = [ "users" ];

text =
let
inherit (config.my.homemanager) homeDir owner;
configDir = "${homeDir}/.config";
in
''
if [ ! -d "${configDir}" ]; then
${pkgs.coreutils}/bin/mkdir -p "${configDir}"
${pkgs.coreutils}/bin/chown "${owner}" "${configDir}"
fi

link_dotfile() {
local source_store_path="$1"
local target_home_path="$2"
local parent_dir
local current_target

if [ -L "$target_home_path" ]; then
current_target="$(${pkgs.coreutils}/bin/readlink -f "$target_home_path" 2>/dev/null)"

if [ "$current_target" = "$source_store_path" ]; then
return
fi
fi

parent_dir="$(${pkgs.coreutils}/bin/dirname "$target_home_path")"

if [ ! -d "$parent_dir" ]; then
${pkgs.coreutils}/bin/mkdir -p "$parent_dir"
${pkgs.coreutils}/bin/chown "${owner}" "$parent_dir"
fi

${pkgs.coreutils}/bin/ln -sfn "$source_store_path" "$target_home_path"
${pkgs.coreutils}/bin/chown -h "${owner}" "$target_home_path"
}

link_dotfile "${./.config/alacritty/alacritty.toml}" "${configDir}/alacritty/alacritty.toml"
link_dotfile "${./.config/mako/config}" "${configDir}/mako/config"
link_dotfile "${./.config/mpv/mpv.conf}" "${configDir}/mpv/mpv.conf"
link_dotfile "${./.config/niri/config.kdl}" "${configDir}/niri/config.kdl"
link_dotfile "${./.config/quickshell}" "${configDir}/quickshell"
link_dotfile "${./.config/rofi/colors.rasi}" "${configDir}/rofi/colors.rasi"
link_dotfile "${./.config/rofi/input.rasi}" "${configDir}/rofi/input.rasi"
link_dotfile "${./.config/rofi/launcher.rasi}" "${configDir}/rofi/launcher.rasi"
link_dotfile "${./.config/rofi/menu.rasi}" "${configDir}/rofi/menu.rasi"
link_dotfile "${./.config/rofi/powermenu.rasi}" "${configDir}/rofi/powermenu.rasi"
link_dotfile "${./.config/sway/config}" "${configDir}/sway/config"
link_dotfile "${./.config/swaylock/config}" "${configDir}/swaylock/config"
link_dotfile "${./.config/waybar/config.jsonc}" "${configDir}/waybar/config.jsonc"
link_dotfile "${./.config/waybar/style.css}" "${configDir}/waybar/style.css"
link_dotfile "${./.config/mimeapps.list}" "${configDir}/mimeapps.list"

link_dotfile "${./.icons/default/index.theme}" "${homeDir}/.icons/default/index.theme"

link_dotfile "${./.scripts/blue.sh}" "${homeDir}/.scripts/blue.sh"
link_dotfile "${./.scripts/powermenu.sh}" "${homeDir}/.scripts/powermenu.sh"
link_dotfile "${./.scripts/redfilter.sh}" "${homeDir}/.scripts/redfilter.sh"
link_dotfile "${./.scripts/wifi.sh}" "${homeDir}/.scripts/wifi.sh"

link_dotfile "${./.bashrc}" "${homeDir}/.bashrc"
'';
};
};
}
