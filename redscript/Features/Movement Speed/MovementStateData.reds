module WalkByDefault.MovementSpeed

import WalkByDefault.Core.MovementState

class MovementStateData {
  private let m_movementState: MovementState = MovementState.Unknown;
  private let m_statModifierTDBNameDefault: String;

  public func IsValid() -> Bool {
    return !Equals(this.m_movementState, MovementState.Unknown);
  }

  public func GetEnum() -> MovementState {
    return this.m_movementState;
  }

  public func GetTweakDBName() -> String {
    return this.m_statModifierTDBNameDefault;
  }

  public static func Initialize(state: MovementState, name: String) -> ref<MovementStateData> {
    let data = new MovementStateData();
    data.m_movementState = state;
    data.m_statModifierTDBNameDefault = name;

    return data;
  }
}