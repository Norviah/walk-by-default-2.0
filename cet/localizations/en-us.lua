local localization = {
  modName = "Walk by Default 2.0",

  errors = {
    missingCodeware = "Error: Missing Codeware",
    missingNativeSettings = "Error: Missing Native Settings"
  },

  menu = {
    subcategories = {
      settings = "Settings - Don't forget to reload a save after changing the speed values",
      keyboardBind = "Toggle Walk - Keyboard Binds",
      gamepadBind = "Toggle Walk - Gamepad Binds"
    },

    settings = {
      keyboardBind = {
        keybindLabel = "Key",
        isHoldLabel = "Is Hold",
        keybindDescription = "Bind a key that is part of the hotkey",
        isHoldDescription = "Controls whether the bound key below needs to be held down for some time to be activated",
        maxKeysLabel = "Hotkey Keys Amount",
        maxKeysDescription =
        "Changes how many keys this hotkey has, all of them have to pressed for the hotkey to be activated",
      },

      gamepadBind = {
        keybindLabel = "Button",
        isHoldLabel = "Is Hold",
        keybindDescription = "Bind a button that is part of the hotkey",
        isHoldDescription = "Controls whether the bound button below needs to be held down for some time to be activated",
        maxKeysLabel = "Hotkey Buttons Amount",
        maxKeysDescription =
        "Changes how many buttons this hotkey has, all of them have to pressed for the hotkey to be activated",
      },

      walkingSpeed = {
        description =
        "The movement speed for the player when the walking state is toggled using the 'Toggle Walk' bind below (vanilla value is 1.5).",
        label = "Walking Speed",
      },

      joggingSpeed = {
        description = "The default movement speed for the player when loading into the game (vanilla value is 3.5).",
        label = "Jogging Speed",
      },

      sprintingSpeed = {
        description = "The movement speed for the player when sprinting (vanilla value is 7.5).",
        label = "Sprinting Speed",
      },

      crouchSpeed = {
        description = "The movement speed for the player when crouching (vanilla value is 1.5).",
        label = "Crouching Speed",
      },

      crouchSprintSpeed = {
        description = "The movement speed for the player when crouch sprinting (vanilla value is 5.0).",
        label = "Crouch Sprinting Speed",
      },

      persistSystem = {
        description =
        "Prevents the game from disabling the walking state.\n\nIn vanilla Cyberpunk, various actions will force disable the walking state, such as sprinting or entering combat. Enabling this option will prevent the game from disabling this state, allowing you to persist in the walking state permanently.",
        label = "Persist System",
      },

      toggleWalkingStateWithCombat = {
        description =
        "Toggles the walking state according to when the player enters or leaves combat.\n\nIf the movement speed for the walking state is slow, it could get annoying entering combat and walking a snail's pace, if this option is enabled, the walking state is force disabled when entering combat and re-enabled when leaving combat.",
        label = "Toggle Walking State With Combat",
      },
    }
  }
}

return localization
