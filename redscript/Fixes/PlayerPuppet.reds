module WalkByDefault.Fixes

@replaceMethod(PlayerPuppet)
private final func ProcessToggleWalkInput() -> Void {
  let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
  psmEvent.id = n"ToggleWalkInputRegistered";
  psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
  psmEvent.value = true;

  this.GetControlledPuppet().QueueEvent(psmEvent);
}