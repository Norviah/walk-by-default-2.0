local GameUI = require("lib/GameUI")

local settings = require("utils/settings")
local config = require("utils/config")
local inputManager = require("utils/inputManager")
local menu = require("utils/menu")
local localization = require("utils/localization")

registerForEvent("onInit", function()
  -- ---
  -- SETUP / INITIALIZATION
  -- ---

  local translations = localization.GetLocalization()

  config.load()
  inputManager.onInit()
  menu.setup(translations)

  if not Codeware then -- Required codeware for the inputs
    print("[" .. translations.modName .. "] " .. translations.errors.missingCodeware)
  end

  -- Listens for the user to navigate away from the settings menu, saving and
  -- pushing settings when they do.
  GameUI.Listen("MenuNav", function(state)
    if state.lastSubmenu ~= nil and state.lastSubmenu == "Settings" then
      PushToTweakDB()
      config.save()
    end
  end)

  -- As this mod makes the game look at the `Stand_cpo` record for movement data
  -- for walking, we'll make this record the same as the crouch record by making
  -- different values the same.

  -- There's probably a better way to do this, but `CloneRecord` didn't work so ¯\_(ツ)_/¯

  TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_cpo_inline2.value", 32) -- default 24 / crouch default is 32
  TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_cpo_inline3.value", 32) -- default 24 / crouch default is 32

  PushToTweakDB()

  -- ---
  -- LOGIC
  -- ---

  require("features/persist")
  require("fixes/sceneMovement")
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
  TweakDB:SetFlat(settings.crouchSprintSpeed.tweakDBKey, settings.crouchSprintSpeed.value)
end

return {
  GetLanguageCode = localization.GetLanguageCode,
}
