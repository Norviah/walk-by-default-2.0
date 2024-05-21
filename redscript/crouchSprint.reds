/**
 * Wraps the `CrouchSprintDecisions.ToCrouch` method to not check whether if the
 * player had the walk state toggled before entering the crouch state.
 *
 * For some reason, when the player tries to sprint while crouching, the game will
 * prevent them from doing so if they had the walk state toggled before crouching.
 * This script will remove this check, allowing the player to sprint while crouching
 * regardless of the state they entered crouch from.
 */
@replaceMethod(CrouchSprintDecisions)
protected const func ToCrouch(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let minLinearVelocityThreshold: Float;
  let minStickInputThreshold: Float;
  if !this.IsTouchingGround(scriptInterface) {
    return false;
  };
  if this.GetInStateTime() < this.GetStaticFloatParameterDefault("minTimeToExit", 1.00) {
    return false;
  };
  if scriptInterface.IsActionJustPressed(n"Crouch") || scriptInterface.IsActionJustPressed(n"Jump") || scriptInterface.IsActionJustTapped(n"ToggleCrouch") || scriptInterface.IsActionJustHeld(n"ToggleCrouch") {
    stateContext.SetConditionBoolParameter(n"CrouchToggled", false, true);
    return true;
  };
  if !scriptInterface.HasStatFlag(gamedataStatType.CanSprint) || scriptInterface.IsActionJustReleased(n"Sprint") || scriptInterface.IsActionJustPressed(n"ToggleSprint") {
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
    return true;
  };
  // if stateContext.GetBoolParameter(n"WalkToggled", true) {
  //   stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
  //   stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
  //   return true;
  // };
  if this.GetInStateTime() >= 0.60 {
    minLinearVelocityThreshold = this.GetStaticFloatParameterDefault("minLinearVelocityThreshold", 0.50);
    if scriptInterface.GetOwnerStateVectorParameterFloat(physicsStateValue.LinearSpeed) < minLinearVelocityThreshold {
      stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
      stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
      return true;
    };
  };
  if !scriptInterface.IsMoveInputConsiderable() {
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
    return true;
  };
  minStickInputThreshold = this.GetStaticFloatParameterDefault("minStickInputThreshold", 0.80);
  if stateContext.GetConditionBool(n"SprintToggled") && DefaultTransition.GetMovementInputActionValue(stateContext, scriptInterface) <= minStickInputThreshold {
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    return true;
  };
  if (scriptInterface.executionOwner as PlayerPuppet).GetStaminaValueUnsafe() <= 1.00 {
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.OpticalCamoCoolPerkShort");
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
    return true;
  };
  if scriptInterface.IsActionJustReleased(n"Sprint") {
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
    return true;
  };
  return false;
}
