module WalkByDefault.Core

public class Config extends ScriptableService {
  // ---
  // GENERAL
  // ---

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-General-Enable-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-General-Enable-Description")
  private let isEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-General-PersistSystem-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-General-PersistSystem-Description")
  private let persistSystem: Bool = true;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-General-ToggleStateInCombat-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-General-ToggleStateInCombat-Description")
  private let toggleWalkingStateWithCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-General-PreserveSpeedInScenes-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-General-PreserveSpeedInScenes-Description")
  private let preserveMovementSpeedInScenes: Bool = true;

  // ---
  // MOVEMENT SPEED
  // ---

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-MovementSpeed")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-MovementSpeed-Walking-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-MovementSpeed-Walking-Description")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  private let walkingSpeed: Float = 3.5;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-MovementSpeed")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-MovementSpeed-Jogging-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-MovementSpeed-Jogging-Description")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  private let joggingSpeed: Float = 1.5;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-MovementSpeed")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-MovementSpeed-Sprinting-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-MovementSpeed-Sprinting-Description")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  private let sprintingSpeed: Float = 7.5;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-MovementSpeed")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-MovementSpeed-Crouching-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-MovementSpeed-Crouching-Description")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  private let crouchingSpeed: Float = 1.5;

  @runtimeProperty("ModSettings.mod", "Walk by Default 2.0")
  @runtimeProperty("ModSettings.category", "WalkByDefault-Config-MovementSpeed")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "WalkByDefault-Config-MovementSpeed-CrouchSprinting-DisplayName")
  @runtimeProperty("ModSettings.description", "WalkByDefault-Config-MovementSpeed-CrouchSprinting-Description")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  private let crouchSprintingSpeed: Float = 5.0;

  private cb func OnLoad() -> Void {
    ModSettings.RegisterListenerToClass(this);
  }

  private cb func OnReload() -> Void {
    ModSettings.RegisterListenerToClass(this);
  }

  private cb func OnUninitialize() -> Void {
    ModSettings.UnregisterListenerToClass(this);
  }

  public func IsEnabled() -> Bool {
    return this.isEnabled;
  }

  public func IsPersistSystemEnabled() -> Bool {
    return this.isEnabled && this.persistSystem;
  }

  public func ShouldToggleWalkingStateWithCombat() -> Bool {
    return this.isEnabled && this.toggleWalkingStateWithCombat;
  }

  public func ShouldPreserveMovementSpeedInScenes() -> Bool {
    return this.isEnabled && this.preserveMovementSpeedInScenes;
  }

  public func GetSpeed(state: MovementState) -> Float {
    switch state {
      case MovementState.Jogging:
        return this.joggingSpeed;
      case MovementState.Walking:
        return this.walkingSpeed;
      case MovementState.Sprinting:
        return this.sprintingSpeed;
      case MovementState.Crouching:
        return this.crouchingSpeed;
      case MovementState.CrouchSprinting:
        return this.crouchSprintingSpeed;
    }

    return 3.5;
  }

  public final static func GetInstance() -> ref<Config> {
    return GameInstance.GetScriptableServiceContainer().GetService(n"WalkByDefault.Core.Config") as Config;
  }
}