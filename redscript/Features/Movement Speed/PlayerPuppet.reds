module WalkByDefault.MovementSpeed

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


// ---
// FLAGS
// ---

@addField(PlayerPuppet)
private let m_initializedStats: Bool = false;

@addField(PlayerPuppet)
private let m_isClothingModifierEnabled: Bool = false;

// ---
// PROPERTIES
// ---

@addField(PlayerPuppet)
private let m_baseSpeedStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_baseSpeedValue: Float = 3.5;

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

@addField(PlayerPuppet)
private let m_clothingModifiers: array<ref<ClothingModifier>>;


// ---
// HELPERS
// ---

@addMethod(PlayerPuppet)
public func AddStatModifier(modifier: ref<gameStatModifierData>) -> Void {
  this.m_statsSystem.AddModifier(this.m_ownerID, modifier);
}

@addMethod(PlayerPuppet)
public func RemoveStatModifier(modifier: ref<gameStatModifierData>) -> Void {
  this.m_statsSystem.RemoveModifier(this.m_ownerID, modifier);
}

@addMethod(PlayerPuppet)
public func HasStatModifier(statType: gamedataStatType, modifierType: gameStatModifierType, value: Float) -> Bool {
  for detail in this.m_statsSystem.GetStatDetails(this.m_ownerID) {
    if Equals(detail.statType, statType) {
      for modifier in detail.modifiers {
        if Equals(modifierType, modifier.modifierType) && Equals(value, modifier.value) {
          return true;    
        }
      }
    }
  }

  return false;
}

@addMethod(PlayerPuppet)
protected final func SetStatModifierProperty(value: Float, out property: Float, out modifier: ref<gameStatModifierData>) -> Void {
  if IsDefined(modifier) {
    this.RemoveStatModifier(modifier);
  }

  property = value;
  modifier = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, value);

  this.AddStatModifier(modifier);
}

@addMethod(PlayerPuppet)
public func SetMaxSpeed(speed: Float) -> Void {
  this.SetStatModifierProperty(speed, this.m_baseSpeedValue, this.m_baseSpeedStat);
}

@addMethod(PlayerPuppet)
public func SetMaxSpeedModifier(initialModifier: Float) -> Void {
  let modifier: Float;

  if initialModifier > 15.0 {
    modifier = 15.0;
  } else if initialModifier < -this.m_baseSpeedValue {
    modifier = -this.m_baseSpeedValue;
  } else {
    modifier = initialModifier;
  }

  this.SetStatModifierProperty(modifier, this.m_speedModifierValue, this.m_speedModifierStat);
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
protected func AddDefaultMaxSpeed() -> Void {
  this.AddStatModifier(RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_movementState.GetDefaultSpeed()));
}

@addMethod(PlayerPuppet)
protected func RemoveDefaultMaxSpeed() -> Void {
  this.RemoveStatModifier(RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_movementState.GetDefaultSpeed()));
}

@addMethod(PlayerPuppet)
protected func GetDetailedLocomotionState() -> gamePSMDetailedLocomotionStates {
  let defs = GetAllBlackboardDefs();
  let blackboard = this.GetPlayerStateMachineBlackboard();
  let int = blackboard.GetInt(defs.PlayerStateMachine.LocomotionDetailed);

  return IntEnum<gamePSMDetailedLocomotionStates>(int);
}


// ---
// LOGIC
// ---

@addMethod(PlayerPuppet)
protected func InitializeStatModifiers() -> Void {
  if this.m_initializedStats {
    return;
  }

  this.m_baseSpeedStat = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Additive, this.m_baseSpeedValue);
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
  let config = Config.GetInstance();

  this.m_isClothingModifierEnabled = config.IsClothModifierEnabled();
  this.m_statsSystem = this.GetGame().GetStatsSystem();
  this.m_ownerID = Cast<StatsObjectID>(this.GetEntityID());
  this.m_clothingModifiers = GetClothingModifiers();

  if config.IsEnabled() {
    this.InitializeStatModifiers();
  }
  
  return wrappedMethod();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  if this.m_initializedStats {
    this.UninitializeStatModifiers();
  }

  for modifier in this.m_clothingModifiers {
    modifier.NullRef();
  }

  this.m_movementState = null;
  this.m_statsSystem = null;
  
  return wrappedMethod();
}

@addMethod(PlayerPuppet)
public func AddClothingStatModifiers() -> Void {
  for modifier in this.m_clothingModifiers {
    if modifier.IsActive() && modifier.IsState(this.m_movementState.GetEnum()) && !this.HasStatModifier(gamedataStatType.MaxSpeed, modifier.modifierType, modifier.value) {
      this.AddStatModifier(modifier.GetRef());
    }
  }
}

@addMethod(PlayerPuppet)
public func RemoveClothingStatModifiers() -> Void {
  for modifier in this.m_clothingModifiers {
    if modifier.IsActive() {
      this.RemoveStatModifier(modifier.GetRef());
    }
  }
}

@addMethod(PlayerPuppet)
protected func SetMovementState(state: MovementState, TDBName: String) -> Void {
  this.m_movementState = MovementStateData.Initialize(state, TDBName);

  if !this.m_wbdConfig.IsEnabled() {
    return;
  }

  this.RemoveDefaultMaxSpeed();
  this.SetMaxSpeed(this.m_wbdConfig.GetSpeed(state));
  
  if this.m_isClothingModifierEnabled {
    this.AddClothingStatModifiers();
  }
}

@addMethod(PlayerPuppet)
protected func ResetMovementState() -> Void {
  this.m_movementState = null;

  if this.m_initializedStats {
    this.RemoveStatModifier(this.m_baseSpeedStat);
  }

  if this.m_isClothingModifierEnabled {
    this.RemoveClothingStatModifiers();
  }
}

@addMethod(PlayerPuppet)
protected func OnExitModSettingsMenu() -> Void {
  if this.m_wbdConfig.IsEnabled() && !this.m_initializedStats {
    this.m_baseSpeedValue = this.m_wbdConfig.GetSpeed(this.m_movementState.GetEnum());

    this.RemoveDefaultMaxSpeed();
    this.InitializeStatModifiers();
  } else if !this.m_wbdConfig.IsEnabled() && this.m_initializedStats {
    this.UninitializeStatModifiers();
    this.AddDefaultMaxSpeed();
  }

  if IsDefined(this.m_movementState) && this.m_initializedStats {
    let speed: Float = this.m_wbdConfig.GetSpeed(this.m_movementState.GetEnum());

    if !Equals(speed, this.m_baseSpeedValue) {
      this.SetMaxSpeed(speed);
    }
  }

  if this.m_wbdConfig.IsClothModifierEnabled() && !this.m_isClothingModifierEnabled {
    this.m_isClothingModifierEnabled = true;
    this.AddClothingStatModifiers();
  } else if !this.m_wbdConfig.IsClothModifierEnabled() && this.m_isClothingModifierEnabled {
    this.m_isClothingModifierEnabled = false;
    this.RemoveClothingStatModifiers();
  }
}

@addMethod(PlayerPuppet)
protected func ActivateClothingModifier(modifier: ref<ClothingModifier>, added: Bool) -> Void {
  modifier.SetActive(added);

  if !this.m_isClothingModifierEnabled || !modifier.IsState(this.m_movementState.GetEnum()) {
    return;
  }

  if added {
    this.AddStatModifier(modifier.GetRef());
  } else {
    this.RemoveStatModifier(modifier.GetRef());
  }
}

@addMethod(PlayerPuppet)
protected func PrintMaxSpeedStat() -> Void {
  let types: array<gameStatDetailedData> = this.m_statsSystem.GetStatDetails(this.m_ownerID);

  for type in types {
    if Equals(type.statType, gamedataStatType.MaxSpeed) {
      FTLog(s"state: \(!this.m_movementState.IsValid() ? ToString(this.GetDetailedLocomotionState()) : ToString(this.m_movementState.GetEnum()))");
      FTLog(s"max speed: \(this.m_baseSpeedValue)");
      FTLog(s"stat type: \(type.statType)");
      FTLog(s"value: \(type.value)");
    
      for modifier in type.modifiers {
        FTLog(s"  - modifier: \(modifier.modifierType) | value: \(modifier.value)");
      }
    }
  }
}


// ---
// EVENTS
// ---

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

@addMethod(PlayerPuppet)
protected func OnItemModifiedFromSlot(id: ItemID, added: Bool) -> Void {
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
  let itemCategory = itemRecord.ItemCategory();

  if IsDefined(itemCategory) && Equals(itemCategory.Type(), gamedataItemCategory.Clothing) {
    let itemName: String = StrLower(ToString(itemRecord.EntityName()));
    let appearanceName: String = StrLower(ToString(itemRecord.AppearanceName()));

    for modifier in this.m_clothingModifiers {
      if modifier.Is(itemName) || modifier.Is(appearanceName) {
        this.ActivateClothingModifier(modifier, added);
      }
    }
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(event: ref<ItemAddedToSlot>) -> Bool {
  this.OnItemModifiedFromSlot(event.GetItemID(), true);

  return wrappedMethod(event);
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemRemovedFromSlot(event: ref<ItemRemovedFromSlot>) -> Bool {
  this.OnItemModifiedFromSlot(event.GetItemID(), false);

  return wrappedMethod(event);
}