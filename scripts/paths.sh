declare -A paths

# The name of the mod, which will represent the name of the folder when the
# mod is imported/exported to CET and Redscript.
paths[NAME]="WalkByDefault2.0"

# The root of the repository.
paths[ROOT]=$(git rev-parse --show-toplevel)

# The base root for Cyberpunk.
paths[CYBERPUNK_ROOT]="/c/Steam/steamapps/common/Cyberpunk 2077"

# The base path for CET mods.
paths[CET_PATH]="bin/x64/plugins/cyber_engine_tweaks/mods"

# The base path for Redscript scripts.
paths[REDSCRIPT_PATH]="r6/scripts"

export paths