module WalkByDefault.MovementSpeed

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


@addField(PlayerPuppet)
private let m_initializedStats: Bool = false;

@addField(PlayerPuppet)
private let m_baseSpeedStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_maxSpeedValue: Float = 3.5;

@addField(PlayerPuppet)
private let m_speedModifierStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_speedModifierValue: Float = 0.00;

@addField(PlayerPuppet)
private let m_movementState: ref<MovementStateData>;

@addField(PlayerPuppet)
private let m_statsSystem: ref<StatsSystem>;

@addField(PlayerPuppet)
private let m_ownerID: StatsObjectID;


@addMethod(PlayerPuppet)
protected func InitializeStatModifiers() -> Void {
  if this.m_initializedStats {
    return;
  }

  this.m_baseSpeedStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_maxSpeedValue);
  this.m_speedModifierStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_speedModifierValue);

  this.AddStatModifier(this.m_baseSpeedStat);
  this.AddStatModifier(this.m_speedModifierStat);

  this.m_initializedStats = true;
}

@addMethod(PlayerPuppet)
protected func UninitializeStatModifiers() -> Void {
  if !this.m_initializedStats {
    return;
  }

  this.RemoveStatModifier(this.m_baseSpeedStat);
  this.RemoveStatModifier(this.m_speedModifierStat);

  this.m_baseSpeedStat = null;
  this.m_speedModifierStat = null;

  this.m_initializedStats = false;
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  this.m_statsSystem = this.GetGame().GetStatsSystem();
  this.m_ownerID = Cast<StatsObjectID>(this.GetEntityID());

  if Config.GetInstance().IsEnabled() {
    this.InitializeStatModifiers();
  }
  
  return wrappedMethod();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  if this.m_initializedStats {
    this.UninitializeStatModifiers();
  }

  this.m_movementState = null;
  this.m_statsSystem = null;
  
  return wrappedMethod();
}

@addMethod(PlayerPuppet)
public func AddStatModifier(modifier: ref<gameStatModifierData>) -> Void {
  this.m_statsSystem.AddModifier(this.m_ownerID, modifier);
}

@addMethod(PlayerPuppet)
public func RemoveStatModifier(modifier: ref<gameStatModifierData>) -> Void {
  this.m_statsSystem.RemoveModifier(this.m_ownerID, modifier);
}

@addMethod(PlayerPuppet)
private func GetRecordMaxSpeedValue() -> Float {
  let modifierRecordID: TweakDBID = TDBID.Create(this.m_movementState.GetTweakDBName());
  let modifierRecord: ref<StatModifierGroup_Record> = TweakDBInterface.GetRecord(modifierRecordID) as StatModifierGroup_Record;

  if !IsDefined(modifierRecord) {
    return 0.0;
  }

  let modifiers: array<wref<StatModifier_Record>>;
  modifierRecord.StatModifiers(modifiers);

  for rawModifier in modifiers {
    let modifier = rawModifier as ConstantStatModifier_Record;
    let statTypeEnum = modifier.StatTypeHandle().StatType();

    if Equals(statTypeEnum, gamedataStatType.MaxSpeed) {
      return modifier.Value();
    }
  }

  return 0.0;
}

@addMethod(PlayerPuppet)
protected func AddDefaultMaxSpeedStat() -> Void {
  this.AddStatModifier(RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.GetRecordMaxSpeedValue()));
}

@addMethod(PlayerPuppet)
protected func RemoveDefaultMaxSpeedStat() -> Void {
  this.RemoveStatModifier(RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.GetRecordMaxSpeedValue()));
}

@addMethod(PlayerPuppet)
protected final func SetStatModifierData(value: Float, out property: Float, out modifier: ref<gameStatModifierData>) -> Void {
  if IsDefined(modifier) {
    this.RemoveStatModifier(modifier);
  }

  property = value;
  modifier = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, value);

  this.AddStatModifier(modifier);
}

@addMethod(PlayerPuppet)
public func SetMaxSpeed(speed: Float) -> Void {
  this.SetStatModifierData(speed, this.m_maxSpeedValue, this.m_baseSpeedStat);
}

@addMethod(PlayerPuppet)
public func SetMaxSpeedModifier(initialModifier: Float) -> Void {
  let modifier: Float;

  if initialModifier > 15.0 {
    modifier = 15.0;
  } else if initialModifier < -this.m_maxSpeedValue {
    modifier = -this.m_maxSpeedValue;
  } else {
    modifier = initialModifier;
  }

  this.SetStatModifierData(modifier, this.m_speedModifierValue, this.m_speedModifierStat);
}

@addMethod(PlayerPuppet)
public func IncreaseMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(this.m_speedModifierValue + this.m_wbdConfig.GetModifyAmount());
}

@addMethod(PlayerPuppet)
public func DecreaseMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(this.m_speedModifierValue - this.m_wbdConfig.GetModifyAmount());
}

@addMethod(PlayerPuppet)
public func ResetMaxSpeedModifier() -> Void {
  this.SetMaxSpeedModifier(0.00);
}

@addMethod(PlayerPuppet)
protected func SetMovementState(state: MovementState, TDBName: String) -> Void {
  this.m_movementState = MovementStateData.Initialize(state, TDBName);

  if this.m_wbdConfig.IsEnabled() {
    this.RemoveDefaultMaxSpeedStat();
    this.SetMaxSpeed(this.m_wbdConfig.GetSpeed(state));
  }
}

@addMethod(PlayerPuppet)
protected func ResetMovementState() -> Void {
  this.m_movementState = null;

  if this.m_initializedStats {
    this.RemoveStatModifier(this.m_baseSpeedStat);
  }
}

@addMethod(PlayerPuppet)
protected func OnExitModSettingsMenu() -> Void {
  if this.m_wbdConfig.IsEnabled() && !this.m_initializedStats {
    this.m_maxSpeedValue = this.m_wbdConfig.GetSpeed(this.m_movementState.GetEnum());

    this.RemoveDefaultMaxSpeedStat();
    this.InitializeStatModifiers();
  } else if !this.m_wbdConfig.IsEnabled() && this.m_initializedStats {
    this.UninitializeStatModifiers();
    this.AddDefaultMaxSpeedStat();
  }

  if this.m_wbdConfig.IsEnabled() && !IsDefined(this.m_movementState) {
    let speed: Float = this.m_wbdConfig.GetSpeed(this.m_movementState.GetEnum());

    if !Equals(speed, this.m_maxSpeedValue) {
      this.SetMaxSpeed(speed);
    }
  }
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
  let types: array<gameStatDetailedData> = this.m_statsSystem.GetStatDetails(this.m_ownerID);

  for type in types {
    if Equals(type.statType, gamedataStatType.MaxSpeed) {
      FTLog(s"state: \(!this.m_movementState.IsValid() ? ToString(this.GetDetailedLocomotionState()) : ToString(this.m_movementState.GetEnum()))");
      FTLog(s"max speed: \(this.m_maxSpeedValue)");
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

  if !ListenerAction.IsButtonJustReleased(action) {
    return result;
  } else if Equals(ListenerAction.GetName(action), n"PrintMovementSpeed") {
    this.GetControlledPuppet().PrintMaxSpeedStat();
  }

  if !this.m_wbdConfig.IsEnabled() {
    return result;
  }

  if Equals(ListenerAction.GetName(action), n"IncreaseMovementSpeed") {
    this.GetControlledPuppet().IncreaseMaxSpeedModifier();
  } else if Equals(ListenerAction.GetName(action), n"DecreaseMovementSpeed") {
    this.GetControlledPuppet().DecreaseMaxSpeedModifier();
  } else if Equals(ListenerAction.GetName(action), n"ResetMovementSpeed") {
    this.GetControlledPuppet().ResetMaxSpeedModifier();
  }

  return result;
}

@wrapMethod(MenuScenario_BaseMenu)
protected final func SwitchMenu(menuName: CName, opt userData: ref<IScriptable>, opt context: ScreenDisplayContext) -> Void {
  if Equals(menuName, n"pause_menu") && Equals(this.m_currMenuName, n"mod_settings_main") {
    GetPlayer(GetGameInstance()).OnExitModSettingsMenu();
  }

  wrappedMethod(menuName, userData, context);
}