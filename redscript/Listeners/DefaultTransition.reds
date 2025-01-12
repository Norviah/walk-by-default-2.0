module WalkByDefault.Listeners

import WalkByDefault.Core.Config

@addField(DefaultTransition)
private let m_wbdConfig: wref<Config>;

@addMethod(DefaultTransition)
protected func GetWBDConfig() -> ref<Config> {
  if !IsDefined(this.m_wbdConfig) {
    this.m_wbdConfig = Config.GetInstance();
  }

  return this.m_wbdConfig;
}

@wrapMethod(DefaultTransition)
protected const final func ForceDisableToggleWalk(stateContext: ref<StateContext>) -> Void {
  if !this.GetWBDConfig().IsPersistSystemEnabled() {
    wrappedMethod(stateContext);
  }
}

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if stateContext.GetBoolParameter(n"WalkToggled", true) || stateContext.GetBoolParameter(n"SprintFromWalk", true) {
    stateContext.SetPermanentBoolParameter(n"SprintFromWalk", true, true);
  } else {
    stateContext.SetPermanentBoolParameter(n"SprintFromWalk", false, true);
  }

  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(StandEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if stateContext.GetBoolParameter(n"SprintFromWalk", true) {
    if this.GetWBDConfig().IsPersistSystemEnabled() {
      stateContext.SetPermanentBoolParameter(n"WalkToggled", true, true);
    }

    stateContext.SetPermanentBoolParameter(n"SprintFromWalk", false, true);
  }

  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(SceneTierIIEvents)
protected final func UpdateSpeedValue(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  if this.GetWBDConfig().ShouldPreserveMovementSpeedInScenes() {
    return 0.0;
  } else {
    return wrappedMethod(stateContext, scriptInterface);
  }
}