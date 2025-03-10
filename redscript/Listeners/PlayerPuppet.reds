module WalkByDefault.Listeners

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


// Here is the main function you can use to define what modifiers for clothings
// you want to apply. Each clothing modifier must have these properties:
//
//   - name (String): The name of the clothing item to apply the modifier to,
//     which is case insensitive. If an equipped clothing item has the specified
//     substring in its name, the modifier will be applied. 
//
//     For example, if an equipped item has the name "x_y_socks_x" and you set the
//     modifier's name to "sock", the modifier is applied as the item has "sock"
//     in its name.
//
//   - percentage (Float): The percentage to multiply the movement speed by.
//     Any value > 1 will increase the movement speed, and any value < 1 will
//     decrease the movement speed.
//
//   - state (MovementState): The state to apply the modifier to. Here are all
//     of the supported states:
//       - MovementState.Jogging
//       - MovementState.Walking
//       - MovementState.Sprinting
//       - MovementState.Crouching
//       - MovementState.CrouchSprinting
//       - MovementState.AimWalking
//
// For example, there already is a definition for heels, which will decrease the
// player's movement speed by 25% if they sprint with heels on. Each state will need
// a separate definition.

// If you want to check the modifiers for your current movement state, you can
// press "backspace" (by default) on your keyboard. If you have CET, open the 
// "Game Log" tab and the modifiers will be printed there, for example:
//
//   state: Sprint
//   max speed: 7.500000
//   stat type: MaxSpeed
//   value: 5.906244
//     - modifier: Additive | value: 7.500000
//     - modifier: Additive | value: 0.000000
//     - modifier: Multiplier | value: 0.750000
//
// The above example is what's printed when sprinting with heels on. If you have
// a clothing item equipped defined in this function, the `multiplier` modifier
// will be printed. if you do not, that modifier won't be printed.

// When adding a new modifier, make sure to add a comma after the previous
// modifier in the array. As an example, if I want to add a new modifier for
// socks, I would have it look like this:
// 
//   return [
//     new ClothingModifier("Heels", 0.75, MovementState.Sprinting),
//     new ClothingModifier("Heels", 0.75, MovementState.CrouchSprinting),
//     new ClothingModifier("Sock", 0.90, MovementState.Sprinting),
//     new ClothingModifier("Sock", 0.90, MovementState.CrouchSprinting)
//   ]
//
// Additionally, you can edit this file whenever you want but in order to see 
// any changes take effect, you either need to restart the game or reload scripts
// by using Red Hot Tools in CET. To install Red Hot Tools, follow these steps:
//
//   - 1. Go to: https://github.com/psiberx/cp2077-red-hot-tools 
//   - 2. Complete steps 1-3 in the install instructions
//
// If it's installed correctly, in CET, there should now be a "Hot Reload" window,
// go to the scripts tab (you may have to click the three dots in the top right
// corner and click "Hot Reload") and then click the "Reload Scripts" button (after
// you have saved this file). Then your changes should take effect.

public abstract func GetClothingModifiers() -> array<ClothingModifier> {
  return [
    new ClothingModifier("Heels", 0.75, MovementState.Sprinting),
    new ClothingModifier("Heels", 0.75, MovementState.CrouchSprinting)
  ];
}

@addMethod(PlayerPuppet)
protected func UpdateClothingModifier(itemRecord: ref<Item_Record>, slotID: TweakDBID, add: Bool) -> Void {
  let clothingModifiers = GetClothingModifiers();

  let entityName: String = StrLower(ToString(itemRecord.EntityName()));
  let appearanceName: String = StrLower(ToString(itemRecord.AppearanceName()));

  let reload: Bool = false;

  for modifier in clothingModifiers {
    let name: String = StrLower(modifier.name);

    if StrContains(entityName, name) || StrContains(appearanceName, name) {
      if add {
        ArrayPush(this.m_clothingModifiers, modifier);
      } else {
        ArrayRemove(this.m_clothingModifiers, modifier);
      }

      if !reload {
        reload = true;
      }
    }
  }

  if reload {
    this.ReloadClothingModifiers();
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(event: ref<ItemAddedToSlot>) -> Bool {
  let itemType: gamedataItemCategory;
  let itemID: ItemID = event.GetItemID();
  let itemTDBID: TweakDBID = ItemID.GetTDBID(itemID);
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);
  let slotID: TweakDBID = event.GetSlotID();

  if IsDefined(itemRecord) && IsDefined(itemRecord.ItemCategory()) {
    itemType = itemRecord.ItemCategory().Type();
  };

  if Equals(itemType, gamedataItemCategory.Clothing) {
    this.UpdateClothingModifier(itemRecord, slotID, true);
  }

  return wrappedMethod(event);
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemRemovedFromSlot(event: ref<ItemRemovedFromSlot>) -> Bool {
  let itemType: gamedataItemCategory;
  let itemID: ItemID = event.GetItemID();
  let itemTDBID: TweakDBID = ItemID.GetTDBID(itemID);
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);
  let slotID: TweakDBID = event.GetSlotID();

  if IsDefined(itemRecord) && IsDefined(itemRecord.ItemCategory()) {
    itemType = itemRecord.ItemCategory().Type();
  };

  if Equals(itemType, gamedataItemCategory.Clothing) {
    this.UpdateClothingModifier(itemRecord, slotID, false);
  }

  return wrappedMethod(event);
}

struct ClothingModifier {
  let name: String;
  let percentage: Float;
  let state: MovementState;
}


@addField(PlayerPuppet)
private let m_wbdConfig: ref<Config>;

@addField(PlayerPuppet)
private let m_movementState: MovementState = MovementState.Unknown;

@addField(PlayerPuppet)
private let m_speedModifierStat: ref<gameStatModifierData>;

@addField(PlayerPuppet)
private let m_maxSpeed: Float = 3.5;

@addField(PlayerPuppet)
private let m_cachedSpeedModifier: Float = 0.00;

@addField(PlayerPuppet)
private let m_clothingModifiers: array<ClothingModifier>;


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

  for modifier in this.m_clothingModifiers {
    if Equals(modifier.state, this.m_movementState) {
      statSystem.AddModifier(ownerID, RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Multiplier, modifier.percentage));
    }
  }
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
  let speed = this.m_wbdConfig.GetSpeed(this.m_movementState);

  if this.m_wbdConfig.IsEnabled() && !Equals(this.m_movementState, MovementState.Unknown) && !Equals(speed, this.m_maxSpeed) {
    this.SetMaxSpeed(speed);
  }
}

@addMethod(PlayerPuppet)
protected func ReloadClothingModifiers() -> Void {
  let speed = this.m_wbdConfig.GetSpeed(this.m_movementState);

  if this.m_wbdConfig.IsEnabled() && !Equals(this.m_movementState, MovementState.Unknown) {
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
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Jogging);
  }
}

@addMethod(StandEvents)
public func OnWalkEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Walking);
  }
}

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Sprinting);
  }
}

@wrapMethod(CrouchEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Crouching);
  }
}

@wrapMethod(CrouchSprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.CrouchSprinting);
  }
}

@wrapMethod(AimWalkEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.AimWalking);
  }
}

@wrapMethod(LocomotionGroundEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).ResetMovementState();
  }
}

@wrapMethod(MenuScenario_BaseMenu)
protected final func SwitchMenu(menuName: CName, opt userData: ref<IScriptable>, opt context: ScreenDisplayContext) -> Void {
  if Equals(menuName, n"pause_menu") && Equals(this.m_currMenuName, n"mod_settings_main") {
    GetPlayer(GetGameInstance()).ReloadMovementSpeed();
  }

  wrappedMethod(menuName, userData, context);
}
