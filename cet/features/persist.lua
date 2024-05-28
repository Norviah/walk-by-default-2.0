--- ---
--- Persist System
--- ---

--- The goal for the persist system is to prevent the game from disabling the
--- walking state, allowing the player to persist in the walking state
--- permanently.

local settings = require("utils/settings")

--- Overrides the `DefaultTransition.ForceDisableToggleWalk` method to not execute
--- anything if the persist system is enabled.
---
--- This method is called in various places to force disable the walking state,
--- instead of going through each instance that calls the method, we'll just make
--- the method do nothing.
---
--- Implemented similar logic from the `No Walk Auto Disable` mod.
--- @see https://www.nexusmods.com/cyberpunk2077/mods/3966.
---
--- @param self DefaultTransition
--- @param stateContext StateContext
--- @param wrappedMethod fun(stateContext: StateContext): nil
Override("DefaultTransition", "ForceDisableToggleWalk", function(self, stateContext, wrappedMethod)
  if not settings.persistSystem.value then
    return wrappedMethod(stateContext)
  end
end)

--- Overrides the `PlayerPuppet.OnCombatStateChanged` method to not disable the
--- walking state if the persist system is enabled.
---
--- In vanilla, once the player enters combat, this method is called and will force
--- disable the walking state. We'll override this method to not do this if the
--- persist system is enabled.
---
--- Implemented similar logic from the `No Walk Auto Disable` mod.
--- @see https://www.nexusmods.com/cyberpunk2077/mods/3966.
---
--- @param self PlayerPuppet
--- @param newState Int32
--- @param wrappedMethod fun(newState: Int32): Bool
Override("PlayerPuppet", "OnCombatStateChanged", function(self, newState, wrappedMethod)
  local inCombat = newState == 1

  if inCombat ~= self.inCombat then
    if not inCombat then
      self:GetPS():SetCombatExitTimestamp(EngineTime.ToFloat(GameInstance.GetTimeSystem():GetSimTime()))
    end

    self.inCombat = inCombat
    self:UpdateVisibility()

    if not self.inCombat then
      self.hasBeenDetected = false
    else
      self:SetIsBeingRevealed(false);
      self:GetPlayerPerkDataBlackboard():SetUint(GetAllBlackboardDefs().PlayerPerkData.EntityNoticedPlayer, 0, true)
      local bboard = self:GetPlayerPerkDataBlackboard();
      local combatTimeStamp = EngineTime.ToFloat(GameInstance.GetSimTime());
      bboard:SetFloat(GetAllBlackboardDefs().PlayerPerkData.CombatStateTime, combatTimeStamp, true);
    end

    if settings.toggleWalkingStateWithCombat.value or not settings.persistSystem.value then
      local psmEvent = PSMPostponedParameterBool:new();

      if settings.toggleWalkingStateWithCombat.value and not inCombat then
        psmEvent.id = CName("ToggleWalkInputRegistered")
      else
        psmEvent.id = CName("ForceDisableToggleWalk")
      end

      psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
      psmEvent.value = true;
      self:QueueEvent(psmEvent);
    end

    GameInstance.GetPlayerSystem():PlayerEnteredCombat(self.inCombat);
  end

  if inCombat then
    self:GetTargetTrackerComponent():RemoveHostileCamerasFromThreats()
    self:GetSensorObjectComponent():RemoveForcedSensesTracing(gamedataSenseObjectType.Camera, EAIAttitude.AIA_Hostile)
  else
    self:GetSensorObjectComponent():SetForcedSensesTracing(gamedataSenseObjectType.Camera, EAIAttitude.AIA_Hostile)
  end
end)

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
  if stateContext:GetBoolParameter("WalkByDefault_SprintFromWalk", true) then
    if settings.persistSystem.value and not stateContext:GetBoolParameter("ForceDisableToggleWalk", true) then
      stateContext:SetPermanentBoolParameter("WalkToggled", true, true)
    end

    stateContext:SetPermanentBoolParameter("WalkByDefault_SprintFromWalk", false, true);
  end
end)
