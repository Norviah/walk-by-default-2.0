source "$(git rev-parse --show-toplevel)/scripts/paths.sh"

rm -rf "${paths[ROOT]}/cet"
rm -rf "${paths[ROOT]}/redscript"

cp -r "${paths[CYBERPUNK_ROOT]}/${paths[CET_PATH]}/${paths[NAME]}/" "${paths[ROOT]}/cet"
cp -r "${paths[CYBERPUNK_ROOT]}/${paths[REDSCRIPT_PATH]}/${paths[NAME]}/" "${paths[ROOT]}/redscript"

cd "${paths[ROOT]}/cet"
rm *.sqlite3 *.log data/*.json