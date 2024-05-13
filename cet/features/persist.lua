--- ---
--- Persist System
--- ---

--- The goal for the persist system is to prevent the game from auto disabling
--- the walk (or toggled) state when the player sprints.

local settings = require("modules/settings")

--- Observes the `SprintEvents.OnEnter` method to set a custom parameter to
--- indicate if the player had entered sprinting from the walking state.
---
--- To describe the problem, when the player begins sprinting, the game will
--- force disable the walking state, whether if the player had it toggled on
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
  if stateContext:GetBoolParameter("WalkToggled", true) or stateContext:GetBoolParameter("WalkByDefault_SprintFromWalk", true) then
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
  if settings.persistWalkingState.value and stateContext:GetBoolParameter("WalkByDefault_SprintFromWalk", true) then
    if not stateContext:GetBoolParameter("ForceDisableToggleWalk", true) then
      stateContext:SetPermanentBoolParameter("WalkToggled", true, true)
    end

    stateContext:SetPermanentBoolParameter("WalkByDefault_SprintFromWalk", false, true);
  end
end)
