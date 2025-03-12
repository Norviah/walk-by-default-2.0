module WalkByDefault.MovementSpeed

import WalkByDefault.Core.Config
import WalkByDefault.Core.MovementState

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

@wrapMethod(SwimmingSurfaceEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Swimming);
  }
}

@wrapMethod(SwimmingSurfaceFastEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.FastSwimming);
  }
}

@wrapMethod(SwimmingDivingEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.Swimming);
  }
}

@wrapMethod(SwimmingFastDivingEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).SetMovementState(MovementState.FastSwimming);
  }
}

@wrapMethod(LocomotionEventsTransition)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  if this.GetWBDConfig().IsEnabled() {
    GetPlayer(scriptInterface.GetGame()).ResetMovementState();
  }
}