# used paths for the scripts

declare -A paths

paths[NAME]="WalkByDefault2.0"

paths[ROOT]=$(git rev-parse --show-toplevel)
paths[BACKUP]="${paths[ROOT]}/backup"
paths[CYBERPUNK_ROOT]="/c/Steam/steamapps/common/Cyberpunk 2077"
paths[CET_PATH]="bin/x64/plugins/cyber_engine_tweaks/mods"
paths[REDSCRIPT_PATH]="r6/scripts"
paths[INPUT_PATH]="r6/input"

export paths