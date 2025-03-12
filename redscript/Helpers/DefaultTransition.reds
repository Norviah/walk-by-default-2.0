module WalkByDefault.Helpers

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