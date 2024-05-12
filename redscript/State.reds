/**
 * Originally, this file was responsible for handling the persist feature of the
 * mod. This feature has been moved to CET, so this file is no longer needed.
 *
 * Instead of removing the file altogether, we'll want to keep it here so users
 * that are updating the mod from an older version will replace the old file, with
 * actual logic, with this file that does nothing.
 *
 * As if we don't do this, whenever old users update the mod, the old `State.reds`
 * script will still be present and will still be executed, conflicting with the
 * logic in the CET section of the mod and most likely causing issues.
 */