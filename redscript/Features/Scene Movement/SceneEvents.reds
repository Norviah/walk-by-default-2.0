module WalkByDefault.SceneMovement

import WalkByDefault.Core.Config

@wrapMethod(SceneTierIIEvents)
protected final func UpdateSpeedValue(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  if this.GetWBDConfig().ShouldPreserveMovementSpeedInScenes() {
    return 0.0;
  } else {
    return wrappedMethod(stateContext, scriptInterface);
  }
}