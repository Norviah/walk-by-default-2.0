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
  -- LOGIC
  -- ---

  --- Observes the `SprintEvents.OnEnter` method to set a custom parameter to
  --- indicate if the player had entered sprinting from the walking state.
  ---
  --- To describe the problem, when the player begins sprinting, the game will
  --- force de-toggle the walking state, whether if the player had it toggled on
  --- or off. What this means is that if the player had the walking state toggled
  --- before sprinting, they will be in the jogging state after they stop
  --- sprinting.
  ---
  --- This method is called once the player begins sprinting, it does other things
  --- related to sprinting, but the notable thing is that this is the function that
  --- is responsible for de-toggling the walking state.
  ---
  --- Disabling the walking state is necessary for the player to sprint, however,
  --- we'll want to persist the state after the player stops sprinting. To do this,
  --- we'll hook onto this method before it executes and set a custom permanent
  --- parameter to indicate if the walking state was toggled before sprinting.
  ---
  --- @param self SprintEvents
  --- @param stateContext StateContext
  --- @param scriptInterface StateGameScriptInterface
  ObserveBefore("SprintEvents", "OnEnter", function(self, stateContext, scriptInterface)
    if stateContext:GetBoolParameter("WalkToggled", true) or stateContext:GetPermanentBoolParameter("WalkByDefault_SprintFromWalk", true) then
      stateContext:SetPermanentBoolParameter("WalkByDefault_SprintFromWalk", true, true);
    else
      stateContext:SetPermanentBoolParameter("WalkByDefault_SprintFromWalk", false, true);
    end
  end)

  --- Observes the `StandEvents.OnEnter` method to re-enable the walking state if the
  --- player had it toggled before doing any action.
  ---
  --- This method is called once the player stands from any action, crouching, sprinting,
  --- jumping, etc. We'll observe this method to re-enable the walking state by setting
  --- the `WalkToggled` flag if the custom parameter we set is true.
  ---
  --- Of course, if the persist system is disabled, we won't do anything.
  ---
  --- @param self SlideEvents
  --- @param stateContext StateContext
  --- @param scriptInterface StateGameScriptInterface
  ObserveBefore("StandEvents", "OnEnter", function(self, stateContext, scriptInterface)
    print("to stand " .. tostring(stateContext:GetBoolParameter("WalkByDefault_SprintFromWalk", true)))
    if settings.persistWalkingState.value and stateContext:GetBoolParameter("WalkByDefault_SprintFromWalk", true) then
      if not stateContext:GetBoolParameter("ForceDisableToggleWalk", true) then
        stateContext:SetPermanentBoolParameter("WalkToggled", true, true)
      end

      stateContext:SetPermanentBoolParameter("WalkByDefault_SprintFromWalk", false, true);
    end
  end)
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
end
