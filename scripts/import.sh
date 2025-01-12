# imports mod files from the game directory to the git directory

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

# delete mod files from the git directory
source "$(git rev-parse --show-toplevel)/scripts/delete.sh"

# copy mod files to the git directory
cp -r "${paths[CYBERPUNK_ROOT]}/${paths[REDSCRIPT_PATH]}/${paths[NAME]}/" "${paths[ROOT]}/redscript"
cp -r "${paths[CYBERPUNK_ROOT]}/${paths[INPUT_PATH]}/${paths[NAME]}.xml" "${paths[ROOT]}/input/${paths[NAME]}.xml"