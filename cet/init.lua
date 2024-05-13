local GameUI = require("modules/lib/GameUI")

local settings = require("modules/settings")
local config = require("modules/config")
local inputManager = require("modules/inputManager")
local menu = require("modules/menu")

registerForEvent("onInit", function()
  -- ---
  -- SETUP / INITIALIZATION
  -- ---

  -- Listens for the user to navigate away from the settings menu, saving and
  -- pushing settings when they do.
  GameUI.Listen("MenuNav", function(state)
    if state.lastSubmenu ~= nil and state.lastSubmenu == "Settings" then
      PushToTweakDB()
      config.save()
    end
  end)

  if not Codeware then -- Required codeware for the inputs
    print("[Walk by Default 2.0] Error: Missing Codeware")
  end

  config.load()
  menu.setup()

  -- As this mod makes the game look at the `Stand_cpo` record for movement data
  -- for walking, we'll make this record the same as the crouch record by making
  -- different values the same.

  -- There's probably a better way to do this, but `CloneRecord` didn't work so ¯\_(ツ)_/¯

  TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_cpo_inline2.value", 32) -- default 24 / crouch default is 32
  TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_cpo_inline3.value", 32) -- default 24 / crouch default is 32

  PushToTweakDB()

  -- ---
  -- LOGIC / FEATURES
  -- ---

  require("features/persist")
end)

registerForEvent("onShutdown", function()
  inputManager.onShutdown()
end)

registerForEvent("onUpdate", function(dt)
  inputManager.onUpdate(dt)
end)

-- Pushes the current loaded settings to TweakDB.
function PushToTweakDB()
  TweakDB:SetFlat(settings.sprintingSpeed.tweakDBKey, settings.sprintingSpeed.value)
  TweakDB:SetFlat(settings.walkingSpeed.tweakDBKey, settings.walkingSpeed.value)
  TweakDB:SetFlat(settings.joggingSpeed.tweakDBKey, settings.joggingSpeed.value)
  TweakDB:SetFlat(settings.crouchSpeed.tweakDBKey, settings.crouchSpeed.value)
end
