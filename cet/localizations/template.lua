-- This file is a starter template for a new localization file.
--
-- To determine your language's code, run this line in the console:
--
--     print(GetMod("WalkByDefault2.0").GetLanguageCode())
--
-- Whatever text is printed must be used as the new name for this file, as an
-- example, if the text printed is `en-us`, you must rename this file to `en-us.lua`.
-- After you have created your translation, you can upload only this file to
-- your mod's page, make sure to also keep the full path of the file, as in your mod
-- should have this structure:
--
--     bin
--     └── x64
--         └── plugins
--             └── cyber_engine_tweaks
--                 └── mods
--                     └── WalkByDefault2.0
--                         └── localizations
--                             └── en-us.lua
--
-- With this structure, whenever the mod is updated with new text, all you need
-- to do is update this file. If no changes are made to the text, then this file
-- should work in future versions without any changes.
--
-- Feel free to delete this comment block when you are done.

local localization = {
  modName = "Walk by Default 2.0",

  errors = {
    missingCodeware = "[string]",
    missingNativeSettings = "[string]"
  },

  menu = {
    subcategories = {
      settings = "[string]",
      keyboardBind = "[string]",
      gamepadBind = "[string]"
    },

    settings = {
      keyboardBind = {
        keybindLabel = "[string]",
        isHoldLabel = "[string]",
        keybindDescription = "[string]",
        isHoldDescription = "[string]",
        maxKeysLabel = "[string]",
        maxKeysDescription = "[string]",
      },

      gamepadBind = {
        keybindLabel = "[string]",
        isHoldLabel = "[string]",
        keybindDescription = "[string]",
        isHoldDescription = "[string]",
        maxKeysLabel = "[string]",
        maxKeysDescription = "[string]",
      },

      walkingSpeed = {
        description = "[string]",
        label = "[string]",
      },

      joggingSpeed = {
        description = "[string]",
        label = "[string]",
      },

      sprintingSpeed = {
        description = "[string]",
        label = "[string]",
      },

      crouchSpeed = {
        description = "[string]",
        label = "[string]",
      },

      crouchSprintSpeed = {
        description = "[string]",
        label = "[string]",
      },

      persistSystem = {
        description = "[string]",
        label = "[string]",
      },

      toggleWalkingStateWithCombat = {
        description = "[string]",
        label = "[string]",
      },
    }
  }
}

return localization
