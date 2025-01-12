# export mod files to the game directory

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

# if there are no mod files, exit
if [ ! -d "${paths[ROOT]}/redscript" ] || [ ! -f "${paths[ROOT]}/input/${paths[NAME]}.xml" ]; then
  echo "No mod files found."
  exit 1
fi

# vars
redscriptDir="${paths[CYBERPUNK_ROOT]}/${paths[REDSCRIPT_PATH]}/${paths[NAME]}/"
xmlFile="${paths[CYBERPUNK_ROOT]}/${paths[INPUT_PATH]}/${paths[NAME]}.xml"

# if the redscript dir doesn't exist, create it
if [[ -d "$redscriptDir" ]]; then
  mkdir -p "$redscriptDir"
fi

# copy the files
cp -r "${paths[ROOT]}/redscript/." "$redscriptDir/"
cp "${paths[ROOT]}/input/${paths[NAME]}.xml" "$xmlFile"