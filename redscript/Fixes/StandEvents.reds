module WalkByDefault.Fixes

@replaceMethod(StandEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let sprintToggledOffWithNoInput: StateResultBool;
  scriptInterface.PushAnimationEvent(n"StandEnter");
  stateContext.SetConditionBoolParameter(n"blockEnteringSlide", false, true);

  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Locomotion, 0);
  this.PlaySound(n"lcm_falling_wind_loop_end", scriptInterface);

  super.OnEnter(stateContext, scriptInterface);

  if stateContext.GetBoolParameter(n"WalkToggled", true) && !stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true) {
    this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
    this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand_cpo");
  } else {
    this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
  };

  if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"ForceStand") {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"KeepState") {
      stateContext.SetConditionBoolParameter(n"CrouchToggled", false, true);
    };
  };

  sprintToggledOffWithNoInput = stateContext.GetTemporaryBoolParameter(n"SprintToggledOffWithNoInput");
  this.m_enteredAfterSprintWithNoInput = sprintToggledOffWithNoInput.valid && sprintToggledOffWithNoInput.value;
}

@replaceMethod(StandEvents)
protected final func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let footstepStimuliSpeedThreshold: Float;
  let playerSpeed: Float;

  if this.IsTouchingGround(scriptInterface) {
    playerSpeed = scriptInterface.GetOwnerStateVectorParameterFloat(physicsStateValue.LinearSpeed);
    footstepStimuliSpeedThreshold = this.GetStaticFloatParameterDefault("footstepStimuliSpeedThreshold", 2.50);

    if playerSpeed > footstepStimuliSpeedThreshold {
      this.BroadcastStimuliFootstepRegular(scriptInterface);
    };
  };

  if stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true) {
    this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
    this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand");
    this.ProcessPermanentBoolParameterToggle(n"WalkToggled", false, stateContext);

    stateContext.RemovePermanentBoolParameter(n"ForceDisableToggleWalk");
    stateContext.RemovePermanentBoolParameter(n"ToggleWalkInputRegistered");
  } else {
    if stateContext.GetBoolParameter(n"ToggleWalkInputRegistered", true) {
      if stateContext.GetBoolParameter(n"WalkToggled", true) {
        this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
        this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand");
        this.ProcessPermanentBoolParameterToggle(n"WalkToggled", false, stateContext);
      } else {
        this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
        this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand_cpo");
        this.ProcessPermanentBoolParameterToggle(n"WalkToggled", true, stateContext);
      };

      stateContext.RemovePermanentBoolParameter(n"ToggleWalkInputRegistered");
    };
  };
}