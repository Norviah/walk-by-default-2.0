/**
 * Wraps the `StandEvents.OnTick` method to change the reference the game uses
 * for movement data when toggling the walking state.
 *
 * This method is called every tick while the player is in the standing state.
 * Once the user toggles the walking state, the method will, by default, set the 
 * player's movement data to that of crouching.
 *
 * Since this mod makes the walking state have its own unique movement data by using
 * an unused modifier group, we'll wrap this method to change the reference the game uses.
 */
@replaceMethod(StandEvents)
protected func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let footstepStimuliSpeedThreshold: Float;
  let playerSpeed: Float;

  if this.IsTouchingGround(scriptInterface) {
    playerSpeed = scriptInterface.GetOwnerStateVectorParameterFloat(physicsStateValue.LinearSpeed);
    footstepStimuliSpeedThreshold = this.GetStaticFloatParameterDefault("footstepStimuliSpeedThreshold", 2.5);
    if playerSpeed > footstepStimuliSpeedThreshold {
      this.BroadcastStimuliFootstepRegular(scriptInterface);
    }
  }

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
        this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Crouch);
        this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand_cpo"); // The only changed line.
        this.ProcessPermanentBoolParameterToggle(n"WalkToggled", true, stateContext);
      }

      stateContext.RemovePermanentBoolParameter(n"ToggleWalkInputRegistered");
    }
  }
}

/**
 * Wraps the `StandEvents.OnEnter` method to change the reference the game uses when
 * toggling the walking state.
 *
 * This method is called once the player enters the standing state, from a sprint,
 * crouch, etc. By default, when the player toggles the walking state while in or
 * before crouching, once the player enters the standing state, the game will apply
 * the movement data for crouching to the player, as the walking state shares the same
 * movement data as crouching.
 *
 * Since this mod makes the walking state have its own unique movement data by using an
 * unused modifier group, we'll wrap this method to change the reference the game uses.
 */
@replaceMethod(StandEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let sprintToggledOffWithNoInput: StateResultBool;
  scriptInterface.PushAnimationEvent(n"StandEnter");
  stateContext.SetConditionBoolParameter(n"blockEnteringSlide", false, true);

  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Locomotion, 0);
  this.PlaySound(n"lcm_falling_wind_loop_end", scriptInterface);

  super.OnEnter(stateContext, scriptInterface);

  if stateContext.GetBoolParameter(n"WalkToggled", true) && !stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true) {
    this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Crouch);
    this.SetModifierGroupForState(scriptInterface, "PlayerLocomotion.player_locomotion_data_Stand_cpo"); // The only changed line.
  } else {
    this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Stand);
  }

  if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"ForceStand") {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"KeepState") {
      stateContext.SetConditionBoolParameter(n"CrouchToggled", false, true);
    }
  }

  sprintToggledOffWithNoInput = stateContext.GetTemporaryBoolParameter(n"SprintToggledOffWithNoInput");
  this.m_enteredAfterSprintWithNoInput = sprintToggledOffWithNoInput.valid && sprintToggledOffWithNoInput.value;
}

