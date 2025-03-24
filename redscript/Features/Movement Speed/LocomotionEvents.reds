module WalkByDefault.MovementSpeed

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState


@addMethod(LocomotionTransition)
protected func SetMovementState(scriptInterface: ref<StateGameScriptInterface>, state: MovementState, name: String) -> Void {
  GetPlayer(scriptInterface.GetGame()).SetMovementState(state, name);
}

@addMethod(LocomotionTransition)
protected func SetMovementState(scriptInterface: ref<StateGameScriptInterface>, state: MovementState) -> Void {
  GetPlayer(scriptInterface.GetGame()).SetMovementState(state, this.m_statModifierTDBNameDefault);
}

@addMethod(LocomotionTransition)
protected func ResetMovementState(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  GetPlayer(scriptInterface.GetGame()).ResetMovementState();
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
    this.ResetMovementState(scriptInterface);

    if isWalkingToggled {
      this.OnJogEnter(stateContext, scriptInterface);
    } else {
      this.OnWalkEnter(stateContext, scriptInterface);
    }
  }
}

@addMethod(StandEvents)
public func OnJogEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.SetMovementState(scriptInterface, MovementState.Jogging);
}

@addMethod(StandEvents)
public func OnWalkEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.SetMovementState(scriptInterface, MovementState.Walking, "PlayerLocomotion.player_locomotion_data_Stand_cpo");
}

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.Sprinting);
}

@wrapMethod(CrouchEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.Crouching);
}

@wrapMethod(CrouchSprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.CrouchSprinting);
}

@wrapMethod(AimWalkEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.AimWalking);
}

@wrapMethod(SwimmingSurfaceEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.Swimming);
}

@wrapMethod(SwimmingSurfaceFastEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.FastSwimming);
}

@wrapMethod(SwimmingDivingEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.Swimming);
}

@wrapMethod(SwimmingFastDivingEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.SetMovementState(scriptInterface, MovementState.FastSwimming);
}

@wrapMethod(LocomotionEventsTransition)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.ResetMovementState(scriptInterface);
}