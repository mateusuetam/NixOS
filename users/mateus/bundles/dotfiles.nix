{ config, lib, pkgs, ... }:

{
options.my.dotfiles = {
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

config = lib.mkIf config.my.dotfiles.enable {

system.activationScripts.dotfiles = {

deps = [ "users" ];

text =
let
inherit (config.my.dotfiles) homeDir owner;
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

link_dotfile "${../../../quickshell/shell}" "${configDir}/quickshell"
link_dotfile "${../settings/.bashrc}" "${homeDir}/.bashrc"
link_dotfile "${../settings/.icons}" "${homeDir}/.icons"
link_dotfile "${../settings/alacritty/alacritty.toml}" "${configDir}/alacritty/alacritty.toml"
link_dotfile "${../settings/niri/config.kdl}" "${configDir}/niri/config.kdl"
link_dotfile "${../settings/preferences/mpv.conf}" "${configDir}/mpv/mpv.conf"
link_dotfile "${../settings/preferences/mimeapps.list}" "${configDir}/mimeapps.list"
'';
};
};
}
