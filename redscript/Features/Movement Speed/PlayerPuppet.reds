module WalkByDefault.MovementSpeed

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


@addField(PlayerPuppet)
private let m_movementState: MovementState = MovementState.Unknown;

@addField(PlayerPuppet)
private let m_speedModifierStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_maxSpeed: Float = 3.5;

@addField(PlayerPuppet)
private let m_cachedSpeedModifier: Float = 0.00;


@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  if IsDefined(this.m_speedModifierStat) {
    this.m_speedModifierStat = null;
  }
  
  return wrappedMethod();
}

@addMethod(PlayerPuppet)
protected func SetMaxSpeed(speed: Float) -> Void {
  let statSystem = GameInstance.GetStatsSystem(this.GetGame());
  let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

  this.m_maxSpeed = speed;

  statSystem.RemoveAllModifiers(ownerID, gamedataStatType.MaxSpeed, true);
  statSystem.AddModifier(ownerID, RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_maxSpeed));

  if !IsDefined(this.m_speedModifierStat) {
    this.m_speedModifierStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_cachedSpeedModifier);
  }

  statSystem.AddModifier(ownerID, this.m_speedModifierStat);
}

@addMethod(PlayerPuppet)
protected func SetMovementState(state: MovementState) -> Void {
  if !Equals(state, MovementState.Unknown) {
    this.m_movementState = state;
    this.SetMaxSpeed(this.m_wbdConfig.GetSpeed(state));
  }
}

@addMethod(PlayerPuppet)
protected func ResetMovementState() -> Void {
  this.m_movementState = MovementState.Unknown;
  this.m_maxSpeed = this.m_wbdConfig.GetSpeed(MovementState.Unknown);
}

@addMethod(PlayerPuppet)
protected func ReloadMovementSpeed() -> Void {
  if this.m_wbdConfig.IsEnabled() && !Equals(this.m_movementState, MovementState.Unknown) {
    return;
  }

  let speed = this.m_wbdConfig.GetSpeed(this.m_movementState);

  if !Equals(speed, this.m_maxSpeed) {
    this.SetMaxSpeed(speed);
  }
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
protected func PrintMaxSpeedStat() -> Void {
  let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
  let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());
  let types = statsSystem.GetStatDetails(ownerID);

  for type in types {
    if Equals(type.statType, gamedataStatType.MaxSpeed) {
      FTLog(s"state: \(Equals(this.m_movementState, MovementState.Unknown) ? ToString(this.GetDetailedLocomotionState()) : ToString(this.m_movementState))");
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

@wrapMethod(MenuScenario_BaseMenu)
protected final func SwitchMenu(menuName: CName, opt userData: ref<IScriptable>, opt context: ScreenDisplayContext) -> Void {
  if Equals(menuName, n"pause_menu") && Equals(this.m_currMenuName, n"mod_settings_main") {
    GetPlayer(GetGameInstance()).ReloadMovementSpeed();
  }

  wrappedMethod(menuName, userData, context);
}