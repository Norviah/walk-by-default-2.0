local settings = {}

-- Settings tables:
-- "id"_"numberOfKey" = The keycode of the binding with ID's key with said index
-- "id"_hold_"numberOfKey" = Is the binding with this ID and the key with the number being a hold down key?
-- "id"_keys = The number of keys that are being used for the binding of ID

settings.keyboardBind = {
  keybindLabel = "Key",
  isHoldLabel = "Is Hold",
  keybindDescription = "Bind a key that is part of the hotkey",
  isHoldDescription = "Controls whether the bound key below needs to be held down for some time to be activated",
  id = "mkbBinding",
  maxKeys = 2,
  maxKeysLabel = "Hotkey Keys Amount",
  maxKeysDescription =
  "Changes how many keys this hotkey has, all of them have to pressed for the hotkey to be activated",
  supportsHold = false,
  defaultValue = {
    ["mkbBinding_1"] = "IK_None",  -- Key 1' keycode of the "mkbBinding"
    ["mkbBinding_2"] = "IK_None",
    ["mkbBinding_hold_1"] = false, -- Is Key 1 of the "mkbBinding" a hold down key?
    ["mkbBinding_hold_2"] = false,
    ["mkbBinding_keys"] = 1        -- How many of the keys are currently being used for the binding "mkbBinding"?
  },
  value = {
    ["mkbBinding_1"] = "IK_None",
    ["mkbBinding_2"] = "IK_None",
    ["mkbBinding_hold_1"] = false,
    ["mkbBinding_hold_2"] = false,
    ["mkbBinding_keys"] = 1
  }
}

settings.gamepadBind = {
  keybindLabel = "Button",
  isHoldLabel = "Is Hold",
  keybindDescription = "Bind a button that is part of the hotkey",
  isHoldDescription = "Controls whether the bound button below needs to be held down for some time to be activated",
  id = "padBinding",
  maxKeys = 3,
  maxKeysLabel = "Hotkey Buttons Amount",
  maxKeysDescription =
  "Changes how many buttons this hotkey has, all of them have to pressed for the hotkey to be activated",
  supportsHold = true,
  defaultValue = {
    ["padBinding_1"] = "IK_Pad_LeftShoulder",
    ["padBinding_2"] = "IK_Pad_X_SQUARE",
    ["padBinding_3"] = "IK_Pad_LeftThumb",
    ["padBinding_hold_1"] = false,
    ["padBinding_hold_2"] = false,
    ["padBinding_hold_3"] = false,
    ["padBinding_keys"] = 2
  },
  value = {
    ["padBinding_1"] = "IK_Pad_LeftShoulder",
    ["padBinding_2"] = "IK_Pad_X_SQUARE",
    ["padBinding_3"] = "IK_Pad_LeftThumb",
    ["padBinding_hold_1"] = false,
    ["padBinding_hold_2"] = false,
    ["padBinding_hold_3"] = false,
    ["padBinding_keys"] = 2
  },
}

settings.walkingSpeed = {
  value = 3.5,
  description =
  "The movement speed for the player when the walking state is toggled using the 'Toggle Walk' bind below (vanilla value is 1.5).",
  label = "Walking Speed",
  defaultValue = 3.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Stand_cpo_inline1.value",
}

settings.joggingSpeed = {
  value = 1.5,
  description = "The default movement speed for the player when loading into the game (vanilla value is 3.5).",
  label = "Jogging Speed",
  defaultValue = 1.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Stand_inline1.value",
}

settings.sprintingSpeed = {
  value = 7.5,
  description = "The movement speed for the player when sprinting (vanilla value is 7.5).",
  label = "Sprinting Speed",
  defaultValue = 7.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Sprint_inline1.value",
}

settings.crouchSpeed = {
  value = 1.5,
  description = "The movement speed for the player when crouching (vanilla value is 1.5).",
  label = "Crouching Speed",
  defaultValue = 1.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Crouch_inline1.value",
}

settings.crouchSprintSpeed = {
  value = 5.0,
  description = "The movement speed for the player when crouch sprinting (vanilla value is 5.0).",
  label = "Crouch Sprinting Speed",
  defaultValue = 5.0,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_CrouchSprint_inline1.value",
}

settings.persistSystem = {
  value = true,
  description =
  "Prevents the game from disabling the walking state.\n\nIn vanilla Cyberpunk, various actions will force disable the walking state, such as sprinting or entering combat. Enabling this option will prevent the game from disabling this state, allowing you to persist in the walking state permanently.",
  label = "Persist System",
  defaultValue = true,
}

settings.toggleWalkingStateWithCombat = {
  value = false,
  description =
  "Toggles the walking state according to when the player enters or leaves combat.\n\nIf the movement speed for the walking state is slow, it could get annoying entering combat and walking a snail's pace, if this option is enabled, the walking state is force disabled when entering combat and re-enabled when leaving combat.",
  label = "Toggle Walking State With Combat",
  defaultValue = false,
}

return settings
