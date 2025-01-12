# packs the mod files into a zip file for nexusmods

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

# Import the mod if it hasn't been imported yet.
if [ ! -d "${paths[ROOT]}/redscript" ] || [ ! -e "${paths[ROOT]}/input/${paths[NAME]}.xml" ]; then
  source "${paths[ROOT]}/scripts/import.sh"
fi

# Create the install directory and copy files to it.

rm -rf "${paths[ROOT]}/install"
mkdir "${paths[ROOT]}/install"
cd "${paths[ROOT]}/install"

mkdir -p "${paths[REDSCRIPT_PATH]}"
cp -r "${paths[ROOT]}/redscript/" "${paths[REDSCRIPT_PATH]}/${paths[NAME]}"

cp -r "${paths[ROOT]}/input" "${paths[ROOT]}/install/${paths[INPUT_PATH]}"

# Zip the install directory.
7z a -tzip "${paths[NAME]}.zip" *