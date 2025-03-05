module WalkByDefault.Localization.Packages

import Codeware.Localization.*

public class Chinese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("WalkByDefault-Title", "移速设置 2.0");

    this.Text("WalkByDefault-Config-General",                                   "一般");
    this.Text("WalkByDefault-Config-General-Enable-DisplayName",                "启用");
    this.Text("WalkByDefault-Config-General-Enable-Description",                "是否启用mod.");
    this.Text("WalkByDefault-Config-General-PersistSystem-DisplayName",         "持久化系统");
    this.Text("WalkByDefault-Config-General-PersistSystem-Description",         "防止游戏禁用步行状态.");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-DisplayName",   "在战斗中切换步行状态");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-Description",   "进入/退出战斗时禁用/启用步行状态，这仅应在移动速度为原版值时启用，即步行状态的速度较慢时");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-DisplayName", "在场景中保持移动速度");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-Description", "防止游戏在场景中降低你的移动速度");
    this.Text("WalkByDefault-Config-General-ModifyAmount-DisplayName",          "Modify Amount");
    this.Text("WalkByDefault-Config-General-ModifyAmount-Description",          "The amount to use when increasing/decreasing your movement speed.");

    this.Text("WalkByDefault-Config-MovementSpeed",                             "移动速度");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-DisplayName",         "移动速度");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-Description",         "切换步行状态时的移动速度(原版值为1.5)");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-DisplayName",         "慢跑速度");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-Description",         "慢跑状态下的移动速度(原版值为3.5)");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-DisplayName",       "冲刺速度");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-Description",       "冲刺时的移动速度(原版值为7.5)");
    this.Text("WalkByDefault-Config-MovementSpeed-AimWalking-DisplayName",      "Aim Walk Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-AimWalking-Description",      "The movement speed while aiming and scanning (vanilla value is 1.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-DisplayName",       "蹲伏速度");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-Description",       "蹲伏时的移动速度(原版值为1.5)");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-DisplayName", "蹲伏冲刺速度");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-Description", "蹲伏冲刺时的移动速度(原版值为5.0)");
  }
}
