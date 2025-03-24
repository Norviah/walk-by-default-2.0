module WalkByDefault.MovementSpeed

import WalkByDefault.Core.MovementState

class ClothingModifier {
  private let name: String;
  private let value: Float;
  private let modifierType: gameStatModifierType;
  private let states: array<MovementState>;

  private let ref: ref<gameStatModifierData>;
  private let active: Bool = false;

  public func Is(name: String) -> Bool {
    return StrContains(StrLower(name), StrLower(this.name));
  }

  public func IsState(state: MovementState) -> Bool {
    return ArrayContains(this.states, state);
  }

  public func IsActive() -> Bool {
    return this.active;
  }

  public func GetRef() -> ref<gameStatModifierData> {
    return this.ref;
  }

  public func GetType() -> gameStatModifierType {
    return this.modifierType;
  }

  public func GetValue() -> Float {
    return this.value;
  }

  public func SetActive(active: Bool) -> Void {
    this.active = active;
  }

  public func NullRef() -> Void {
    this.ref = null;
  }

  public static func Initialize(name: String, modifierType: gameStatModifierType, value: Float, states: array<MovementState>) -> ref<ClothingModifier> {
    let modifier = new ClothingModifier();
    modifier.name = StrLower(name);
    modifier.value = value;
    modifier.modifierType = modifierType;
    modifier.states = states;
    modifier.ref = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, modifierType, value);

    return modifier;
  }
}