module WalkByDefault.PersistSystem

import WalkByDefault.Core.Config

@replaceMethod(PlayerPuppet)
protected cb func OnCombatStateChanged(newState: Int32) -> Bool {
  let bboard: ref<IBlackboard>;
  let combatTimeStamp: Float;
  let psmEvent: ref<PSMPostponedParameterBool>;
  let inCombat: Bool = newState == 1;

  if NotEquals(inCombat, this.m_inCombat) {
    if !inCombat {
      this.GetPS().SetCombatExitTimestamp(EngineTime.ToFloat(GameInstance.GetTimeSystem(this.GetGame()).GetSimTime()));
    };

    this.m_inCombat = inCombat;
    this.UpdateVisibility();

    if !this.m_inCombat {
      this.m_hasBeenDetected = false;
    } else {
      this.SetIsBeingRevealed(false);
      this.GetPlayerPerkDataBlackboard().SetUint(GetAllBlackboardDefs().PlayerPerkData.EntityNoticedPlayer, 0u);
      bboard = this.GetPlayerPerkDataBlackboard();
      combatTimeStamp = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
      bboard.SetFloat(GetAllBlackboardDefs().PlayerPerkData.CombatStateTime, combatTimeStamp);
    };

    if this.m_wbdConfig.ShouldToggleWalkingStateWithCombat() || !this.m_wbdConfig.IsPersistSystemEnabled() {
      psmEvent = new PSMPostponedParameterBool();
      psmEvent.id = this.m_wbdConfig.ShouldToggleWalkingStateWithCombat() && !inCombat ? n"ToggleWalkInputRegistered" : n"ForceDisableToggleWalk";
      psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
      psmEvent.value = true;

      this.QueueEvent(psmEvent);
    }

    GameInstance.GetPlayerSystem(this.GetGame()).PlayerEnteredCombat(this.m_inCombat);
  };

  if inCombat {
    (this.GetTargetTrackerComponent() as TargetTrackingExtension).RemoveHostileCamerasFromThreats();
    this.GetSensorObjectComponent().RemoveForcedSensesTracing(gamedataSenseObjectType.Camera, EAIAttitude.AIA_Hostile);
  } else {
    this.GetSensorObjectComponent().SetForcedSensesTracing(gamedataSenseObjectType.Camera, EAIAttitude.AIA_Hostile);
  };
}