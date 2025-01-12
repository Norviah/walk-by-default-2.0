module WalkByDefault.Misc

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