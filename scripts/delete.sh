# deletes the locally installed files of the mod

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

rm -rf "${paths[ROOT]}/redscript"
rm -rf "${paths[ROOT]}/input/${paths[NAME]}.xml"
