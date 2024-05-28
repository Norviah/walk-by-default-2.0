source "$(git rev-parse --show-toplevel)/scripts/paths.sh"

# Import the mod if it hasn't been imported yet.
if [ ! -d "${paths[ROOT]}/cet" ] || [ ! -d "${paths[ROOT]}/redscript" ]; then
  source "${paths[ROOT]}/scripts/import.sh"
fi

cp -r "${paths[ROOT]}/cet/." "${paths[CYBERPUNK_ROOT]}/${paths[CET_PATH]}/${paths[NAME]}/" 
cp -r "${paths[ROOT]}/redscript/." "${paths[CYBERPUNK_ROOT]}/${paths[REDSCRIPT_PATH]}/${paths[NAME]}/" 