module WalkByDefault.PersistSystem

import WalkByDefault.Core.Config

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
    if this.GetWBDConfig().IsPersistSystemEnabled() && !stateContext.GetBoolParameter(n"ForceDisableToggleWalk", true) {
      stateContext.SetPermanentBoolParameter(n"WalkToggled", true, true);
    }

    stateContext.SetPermanentBoolParameter(n"SprintFromWalk", false, true);
  }

  wrappedMethod(stateContext, scriptInterface);
}