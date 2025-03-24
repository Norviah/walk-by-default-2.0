module WalkByDefault.MovementSpeed

import WalkByDefault.Core.MovementState

class MovementStateData {
  private let m_movementState: MovementState = MovementState.Unknown;
  private let m_defaultSpeed: Float = 0.0;

  public func IsValid() -> Bool {
    return !Equals(this.m_movementState, MovementState.Unknown);
  }

  public func GetEnum() -> MovementState {
    return this.m_movementState;
  }

  public func GetDefaultSpeed() -> Float {
    return this.m_defaultSpeed;
  }

  public static func Initialize(state: MovementState, name: String) -> ref<MovementStateData> {
    let data = new MovementStateData();
    data.m_movementState = state;
    data.m_defaultSpeed = GetRecordMaxSpeedValue(name);

    return data;
  }
}

public abstract static final func GetRecordMaxSpeedValue(name: String) -> Float {
  let modifierRecordID: TweakDBID = TDBID.Create(name);
  let modifierRecord: ref<StatModifierGroup_Record> = TweakDBInterface.GetRecord(modifierRecordID) as StatModifierGroup_Record;

  if !IsDefined(modifierRecord) {
    return 0.0;
  }

  let modifiers: array<wref<StatModifier_Record>>;
  modifierRecord.StatModifiers(modifiers);

  for rawModifier in modifiers {
    let modifier = rawModifier as ConstantStatModifier_Record;

    if IsDefined(modifier) && Equals(modifier.StatTypeHandle().StatType(), gamedataStatType.MaxSpeed) {
      return modifier.Value();
    }
  }

  return 0.0;
}