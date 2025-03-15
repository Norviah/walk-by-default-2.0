module WalkByDefault.Helpers

import WalkByDefault.Core.Config

@addField(PlayerPuppet)
private let m_wbdConfig: ref<Config>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  
  this.m_wbdConfig = Config.GetInstance();
  
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  if IsDefined(this.m_wbdConfig) {
    this.m_wbdConfig = null;
  }
  
  return wrappedMethod();
}

@addMethod(PlayerPuppet)
protected func GetControlledPuppet() -> ref<PlayerPuppet> {
  let puppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;

  if IsDefined(puppet) && puppet.IsJohnnyReplacer() {
    return puppet;
  } else {
    return this;
  }
}