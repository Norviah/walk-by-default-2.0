# backs up all files into `backup`

source "$(git rev-parse --show-toplevel)/scripts/utils.sh"

# get any command-line arguments
argv="$@"

# ensure the backup directory already exists
if [ ! -d "${paths[BACKUP]}" ]; then
  mkdir -p "${paths[BACKUP]}"
fi

# count the number of files in the backup directory
files=$(ls -1 "${paths[BACKUP]}" | wc -l)

# generate the name for the backup
# if no arguments are provided, use the number of files as the name
if [ -z "$argv" ]; then
  name="$files"
else
  name="$argv"
fi

# delete any mod files from the git directory
source "${paths[ROOT]}/scripts/delete.sh" 

# ensure the input loader directory exists
mkdir -p "${paths[ROOT]}/input"

# import mod files to the git directory
source "${paths[ROOT]}/scripts/import.sh"

# create the backup destination directory
mkdir -p "${paths[BACKUP]}/$name"
cd "${paths[BACKUP]}/$name"

# copy the mod files to the backup directory
cp -r "${paths[ROOT]}/redscript/" "redscript"
cp -r "${paths[ROOT]}/input" "input"