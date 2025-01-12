# uninstalls the mod from the game

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

rm -rf "${paths[CYBERPUNK_ROOT]}/${paths[REDSCRIPT_PATH]}/${paths[NAME]}"
rm -rf "${paths[CYBERPUNK_ROOT]}/${paths[INPUT_PATH]}/${paths[NAME]}.xml"