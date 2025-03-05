module WalkByDefault.Listeners

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


@addField(PlayerPuppet)
private let m_wbdConfig: ref<Config>;

@addField(PlayerPuppet)
private let m_speedModifierStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_maxSpeed: Float = 3.5;

@addField(PlayerPuppet)
private let m_cachedSpeedModifier: Float = 0.00;


@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  
  this.m_wbdConfig = Config.GetInstance();
  
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  this.m_wbdConfig = null;
  this.m_speedModifierStat = null;
  
  return wrappedMethod();
}

@addMethod(PlayerPuppet)
protected func GetControlledPuppet() -> ref<PlayerPuppet> {
  let puppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;

  if IsDefined(puppet) && puppet.IsJohnnyReplacer() {
    return puppet;
  } else {
    return this;
  }
}

@replaceMethod(PlayerPuppet)
private final func ProcessToggleWalkInput() -> Void {
  let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
  psmEvent.id = n"ToggleWalkInputRegistered";
  psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
  psmEvent.value = true;

  this.GetControlledPuppet().QueueEvent(psmEvent);
}

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


@addMethod(PlayerPuppet)
protected func SetMaxSpeed(state: MovementState) -> Void {
  let statSystem = GameInstance.GetStatsSystem(this.GetGame());
  let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

  this.m_maxSpeed = this.m_wbdConfig.GetSpeed(state);

  statSystem.RemoveAllModifiers(ownerID, gamedataStatType.MaxSpeed, true);
  statSystem.AddModifier(ownerID, RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_maxSpeed));

  if !IsDefined(this.m_speedModifierStat) {
    this.m_speedModifierStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_cachedSpeedModifier);
  }

  statSystem.AddModifier(ownerID, this.m_speedModifierStat);
}

@addMethod(PlayerPuppet)
protected func SetMaxSpeedModifier(initialModifier: Float) -> Void {
  let statSystem = GameInstance.GetStatsSystem(this.GetGame());
  let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

  let modifier: Float;

  if initialModifier > 15.0 {
    modifier = 15.0;
  } else if initialModifier < -this.m_maxSpeed {
    modifier = -this.m_maxSpeed;
  } else {
    modifier = initialModifier;
  }

  if IsDefined(this.m_speedModifierStat) {
    statSystem.RemoveModifier(ownerID, this.m_speedModifierStat);
  }

  this.m_speedModifierStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, modifier);
  statSystem.AddModifier(ownerID, this.m_speedModifierStat);

  this.m_cachedSpeedModifier = modifier;
}

@addMethod(PlayerPuppet)
protected func IncreaseMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(this.m_cachedSpeedModifier + this.m_wbdConfig.GetModifyAmount());
}

@addMethod(PlayerPuppet)
protected func DecreaseMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(this.m_cachedSpeedModifier - this.m_wbdConfig.GetModifyAmount());
}

@addMethod(PlayerPuppet)
protected func ResetMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(0.00);
}

@addMethod(PlayerPuppet)
protected func GetDetailedLocomotionState() -> gamePSMDetailedLocomotionStates {
  let defs = GetAllBlackboardDefs();
  let blackboard = this.GetPlayerStateMachineBlackboard();
  let int = blackboard.GetInt(defs.PlayerStateMachine.LocomotionDetailed);

  return IntEnum<gamePSMDetailedLocomotionStates>(int);
}

@addMethod(PlayerPuppet)
protected func PrintMaxSpeedStat() -> Void {
  let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
  let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());
  let types = statsSystem.GetStatDetails(ownerID);

  for type in types {
    if Equals(type.statType, gamedataStatType.MaxSpeed) {
      FTLog(s"state: \(this.GetDetailedLocomotionState())");
      FTLog(s"max speed: \(this.m_maxSpeed)");
      FTLog(s"stat type: \(type.statType)");
      FTLog(s"value: \(type.value)");
    
      for modifier in type.modifiers {
        FTLog(s"  - modifier: \(modifier.modifierType) | value: \(modifier.value)");
      }
    }
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let result = wrappedMethod(action, consumer);

  if !this.m_wbdConfig.IsEnabled() || !ListenerAction.IsButtonJustReleased(action) {
    return result;
  }

  if Equals(ListenerAction.GetName(action), n"IncreaseMovementSpeed") {
    this.GetControlledPuppet().IncreaseMaxSpeedModifier();
  } else if Equals(ListenerAction.GetName(action), n"DecreaseMovementSpeed") {
    this.GetControlledPuppet().DecreaseMaxSpeedModifier();
  } else if Equals(ListenerAction.GetName(action), n"ResetMovementSpeed") {
    this.GetControlledPuppet().ResetMaxSpeedModifier();
  } else if Equals(ListenerAction.GetName(action), n"PrintMovementSpeed") {
    this.GetControlledPuppet().PrintMaxSpeedStat();
  }

  return result;
}


@wrapMethod(StandEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let isWalkingDisabled = stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true);
  let isWalkingToggled = stateContext.GetBoolParameter(n"WalkToggled", true);
  let enteredSprintFromWalking = stateContext.GetBoolParameter(n"SprintFromWalk", true);

  let isWalking = !isWalkingDisabled && (isWalkingToggled || enteredSprintFromWalking);

  wrappedMethod(stateContext, scriptInterface);

  if isWalking {
    this.OnWalkEnter(stateContext, scriptInterface);
  } else {
    this.OnJogEnter(stateContext, scriptInterface);
  }
}

@wrapMethod(StandEvents)
protected final func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let isWalkingDisabled = stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true);
  let isWalkingToggled = stateContext.GetBoolParameter(n"WalkToggled", true);
  let isInputRegisted = stateContext.GetBoolParameter(n"ToggleWalkInputRegistered", true);

  wrappedMethod(timeDelta, stateContext, scriptInterface);

  if !isWalkingDisabled && isInputRegisted {
    if isWalkingToggled {
      this.OnJogEnter(stateContext, scriptInterface);
    } else {
      this.OnWalkEnter(stateContext, scriptInterface);
    }
  }
}

@addMethod(StandEvents)
public func OnJogEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMaxSpeed(MovementState.Jogging);
  }
}

@addMethod(StandEvents)
public func OnWalkEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMaxSpeed(MovementState.Walking);
  }
}

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMaxSpeed(MovementState.Sprinting);
  }
}

@wrapMethod(CrouchEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMaxSpeed(MovementState.Crouching);
  }
}

@wrapMethod(CrouchSprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMaxSpeed(MovementState.CrouchSprinting);
  }
}