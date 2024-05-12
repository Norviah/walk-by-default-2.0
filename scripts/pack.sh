source "$(git rev-parse --show-toplevel)/scripts/paths.sh"

# Import the mod if it hasn't been imported yet.
if [ ! -f "${paths[ROOT]}/cet" ] || [ ! -f "${paths[ROOT]}/redscript" ]; then
  source "${paths[ROOT]}/scripts/import.sh"
fi

# Create the install directory and copy mod files to it.

rm -rf "${paths[ROOT]}/install"
mkdir "${paths[ROOT]}/install"
cd "${paths[ROOT]}/install"

mkdir -p "${paths[CET_PATH]}"
cp -r "${paths[ROOT]}/cet/" "${paths[ROOT]}/install/${paths[CET_PATH]}/${paths[NAME]}"

mkdir -p "${paths[REDSCRIPT_PATH]}"
cp -r "${paths[ROOT]}/redscript/" "${paths[ROOT]}/install/${paths[REDSCRIPT_PATH]}/${paths[NAME]}"

# Zip the install directory.
7z a -tzip "${paths[NAME]}.zip" "${paths[ROOT]}/install"