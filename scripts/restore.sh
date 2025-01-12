# restores a backup to the game

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

# get any command-line arguments
argv="$@"

# get the latest backup
latest_folder=$(find "${paths[BACKUP]}" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' 2>/dev/null | sort -n -r | head -n 1 | cut -d' ' -f2-)

# get which backup to restore
# if no arguments are provided, use the latest backup
if [ -z "$argv" ]; then
  folder="$latest_folder"
else
  folder="${paths[BACKUP]}/$argv"
fi

# check if the folder exists
if [ ! -d "$folder" ]; then
  echo "Folder not found: $folder"
  exit 1
fi

# delete from the game directory
source "${paths[ROOT]}/scripts/uninstall.sh"

# uninstall the mod files
source "${paths[ROOT]}/scripts/delete.sh"

# # copy the backup files to the git directory
cp -r "$folder/input" "${paths[ROOT]}/"
cp -r "$folder/redscript" "${paths[ROOT]}/."

# install the mod files
source "${paths[ROOT]}/scripts/export.sh"