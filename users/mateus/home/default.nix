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
description = "Usuário e grupo proprietários dos diretórios e symlinks gerenciados.";
};
};

config = lib.mkIf config.my.homemanager.enable {

systemd.services.homemanager = let inherit (config.my.homemanager) homeDir owner;

configDir = "${homeDir}/.config";
stateId = builtins.substring 0 16 (builtins.hashString "sha256" homeDir);
stateDir = "/var/lib/homemanager";
stateFile = "${stateDir}/${stateId}.tsv";

dotfiles = [
{
bundles = [];
source = ./.bashrc;
target = "${homeDir}/.bashrc";
}

{
bundles = [];
source = ./.config/mimeapps.list;
target = "${configDir}/mimeapps.list";
}

{
bundles = [];
source = ./.icons/default/index.theme;
target = "${homeDir}/.icons/default/index.theme";
}

{
bundles = [ "niri" ];
source = ./.config/niri/config.kdl;
target = "${configDir}/niri/config.kdl";
}

{
bundles = [ "sway" ];
source = ./.config/sway/config;
target = "${configDir}/sway/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/foot/foot.ini;
target = "${configDir}/foot/foot.ini";
}

{
bundles = [ "minimalshell" ];
source = ./.config/mako/config;
target = "${configDir}/mako/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/swaylock/config;
target = "${configDir}/swaylock/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/waybar/config.jsonc;
target = "${configDir}/waybar/config.jsonc";
}

{
bundles = [ "minimalshell" ];
source = ./.config/waybar/style.css;
target = "${configDir}/waybar/style.css";
}
];

bundleEnabled = bundle: lib.attrByPath [ "my" bundle "enable" ] false config;
dotfileEnabled = dotfile: (dotfile.bundles == []) || lib.any bundleEnabled dotfile.bundles;

activeDotfiles = lib.filter dotfileEnabled dotfiles;
inactiveDotfiles = lib.filter (dotfile: !(dotfileEnabled dotfile)) dotfiles;

activeCommands = lib.concatMapStringsSep "\n" (dotfile: '' link_dotfile "${dotfile.source}" "${dotfile.target}" '') activeDotfiles;
inactiveCommands = lib.concatMapStringsSep "\n" (dotfile: '' remove_dotfile "${dotfile.target}" '') inactiveDotfiles;

homemanagerScript =
pkgs.writeShellScript "homemanager" ''
set -Eeuo pipefail

homeDir="${homeDir}"
owner="${owner}"

stateDir="${stateDir}"
stateFile="${stateFile}"

declare -A managed_source=()

load_manifest() {
managed_source=()

[[ -f "$stateFile" ]] || return 0

local target
local source

while IFS=$'\t' read -r target source; do
[[ -n "$target" ]] || continue
[[ -n "$source" ]] || continue
[[ "$target" == /* ]] || continue

managed_source["$target"]="$source"
done < "$stateFile"
}

save_manifest() {
local tmp="''${stateFile}.tmp.$$"
local target

{
printf '%s\n' '# homemanager-manifest-v1'

for target in "''${!managed_source[@]}"; do
printf '%s\t%s\n' "$target" "''${managed_source[$target]}"
done
} |
LC_ALL=C ${pkgs.coreutils}/bin/sort -t $'\t' -k1,1 > "$tmp"

${pkgs.coreutils}/bin/chmod 0644 -- "$tmp"
${pkgs.coreutils}/bin/mv -f -- "$tmp" "$stateFile"
}

manifest_dirty=false

remember_target() {
local target="$1"
local source="$2"

managed_source["$target"]="$source"
manifest_dirty=true
}

forget_target() {
local target="$1"

if [[ -n "''${managed_source[$target]+x}" ]]; then
unset 'managed_source[$target]'
manifest_dirty=true
fi
}

ensure_home() {
if [[ ! -d "$homeDir" || -L "$homeDir" ]]; then
echo "homemanager: HOME inválido ou indisponível: '$homeDir'." >&2
return 1
fi
}

ensure_dir_owned() {
local dir="$1"

if [[ -L "$dir" ]]; then
echo "homemanager: recusando atravessar diretório symlink: '$dir'." >&2
return 1
fi

if [[ -d "$dir" ]]; then
return 0
fi

if [[ -e "$dir" ]]; then
echo "homemanager: '$dir' existe, mas não é um diretório." >&2
return 1
fi

local parent
parent="$(${pkgs.coreutils}/bin/dirname -- "$dir")"

if [[ "$parent" != "/" && "$parent" != "." ]]; then
ensure_dir_owned "$parent"
fi

${pkgs.coreutils}/bin/mkdir -- "$dir"
${pkgs.coreutils}/bin/chown "$owner" -- "$dir"
}

create_new_symlink() {
local source="$1"
local target="$2"

if [[ ! -e "$source" ]]; then
echo "homemanager: source inexistente: '$source'." >&2
return 1
fi

if ! ${pkgs.coreutils}/bin/ln -s -- "$source" "$target"; then
echo "homemanager: não foi possível criar symlink '$target'." >&2
return 1
fi

if ! ${pkgs.coreutils}/bin/chown -h "$owner" -- "$target"; then
${pkgs.coreutils}/bin/rm -f -- "$target"
echo "homemanager: não foi possível definir owner do symlink '$target'." >&2
return 1
fi
}

replace_managed_symlink() {
local source="$1"
local target="$2"

local tmp="''${target}.homemanager.tmp.$$"

${pkgs.coreutils}/bin/rm -f -- "$tmp"
${pkgs.coreutils}/bin/ln -s -- "$source" "$tmp"
${pkgs.coreutils}/bin/chown -h "$owner" -- "$tmp"
${pkgs.coreutils}/bin/mv -Tf -- "$tmp" "$target"
}

link_dotfile() {
local source_store_path="$1"
local target="$2"

local current
local recorded_source

local parent_dir
parent_dir="$(${pkgs.coreutils}/bin/dirname -- "$target")"

ensure_dir_owned "$parent_dir"

if [[ -n "''${managed_source[$target]+x}" ]]; then
recorded_source="''${managed_source[$target]}"

if [[ -L "$target" ]]; then
current="$(${pkgs.coreutils}/bin/readlink -- "$target" 2>/dev/null || true)"

if [[ "$current" == "$recorded_source" ]]; then
if [[ "$current" != "$source_store_path" ]]; then
replace_managed_symlink "$source_store_path" "$target"
remember_target "$target" "$source_store_path"
fi
return 0
fi

echo "homemanager: '$target' não aponta mais para o source gerenciado; preservando." >&2

forget_target "$target"
return 0
fi

if [[ ! -e "$target" ]]; then
create_new_symlink "$source_store_path" "$target"
remember_target "$target" "$source_store_path"
return 0
fi

echo "homemanager: '$target' foi substituído por arquivo/diretório; preservando." >&2
forget_target "$target"
return 0
fi

if [[ -L "$target" ]]; then
current="$(${pkgs.coreutils}/bin/readlink -- "$target" 2>/dev/null || true)"
echo "homemanager: preservando symlink externo: '$target' -> '$current'." >&2
return 0
fi

if [[ -e "$target" ]]; then
echo "homemanager: não sobrescrevendo '$target'." >&2
return 0
fi

create_new_symlink "$source_store_path" "$target"
remember_target "$target" "$source_store_path"
}

remove_dotfile() {
local target="$1"

local current
local recorded_source

[[ -n "''${managed_source[$target]+x}" ]] || return 0

recorded_source="''${managed_source[$target]}"

if [[ ! -L "$target" ]]; then
echo "homemanager: '$target' não é mais um symlink gerenciado; preservando." >&2
forget_target "$target"
return 0
fi

current="$(${pkgs.coreutils}/bin/readlink -- "$target" 2>/dev/null || true)"

if [[ "$current" != "$recorded_source" ]]; then
echo "homemanager: preservando symlink externo/modificado: '$target' -> '$current'." >&2
forget_target "$target"
return 0
fi

${pkgs.coreutils}/bin/rm -f -- "$target"
forget_target "$target"
}

ensure_home
load_manifest

${activeCommands}
${inactiveCommands}

if [[ "$manifest_dirty" == true ]]; then
save_manifest
fi
'';
in
{
description = "Gerenciamento declarativo de dotfiles";

wantedBy = [ "multi-user.target" ];

after = [
"local-fs.target"
];

before = [
"display-manager.service"
"graphical.target"
];

unitConfig.RequiresMountsFor = homeDir;

restartIfChanged = true;

serviceConfig = {
Type = "oneshot";
User = "root";
Group = "root";

StateDirectory = "homemanager";
RemainAfterExit = true;
ExecStart = "${homemanagerScript}";
};
};
};
}
