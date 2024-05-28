local settings = {}

-- Settings tables:
-- "id"_"numberOfKey" = The keycode of the binding with ID's key with said index
-- "id"_hold_"numberOfKey" = Is the binding with this ID and the key with the number being a hold down key?
-- "id"_keys = The number of keys that are being used for the binding of ID

settings.keyboardBind = {
  id = "mkbBinding",
  maxKeys = 2,
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
  id = "padBinding",
  maxKeys = 3,
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
  defaultValue = 3.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Stand_cpo_inline1.value",
}

settings.joggingSpeed = {
  value = 1.5,
  defaultValue = 1.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Stand_inline1.value",
}

settings.sprintingSpeed = {
  value = 7.5,
  defaultValue = 7.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Sprint_inline1.value",
}

settings.crouchSpeed = {
  value = 1.5,
  defaultValue = 1.5,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_Crouch_inline1.value",
}

settings.crouchSprintSpeed = {
  value = 5.0,
  defaultValue = 5.0,
  min = 0,
  max = 30.0,
  step = 0.1,
  tweakDBKey = "PlayerLocomotion.player_locomotion_data_CrouchSprint_inline1.value",
}

settings.persistSystem = {
  value = true,
  defaultValue = true,
}

settings.toggleWalkingStateWithCombat = {
  value = false,
  defaultValue = false,
}

return settings
