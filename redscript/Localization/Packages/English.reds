module WalkByDefault.Localization.Packages

import Codeware.Localization.*

public class English extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("WalkByDefault-Title", "Walk By Default 2.0");

    this.Text("WalkByDefault-Config-General",                                   "General");
    this.Text("WalkByDefault-Config-General-Enable-DisplayName",                "Enable");
    this.Text("WalkByDefault-Config-General-Enable-Description",                "Whether to enable the mod.");
    this.Text("WalkByDefault-Config-General-PersistSystem-DisplayName",         "Persist System");
    this.Text("WalkByDefault-Config-General-PersistSystem-Description",         "Prevents the game from disabling the walking state.");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-DisplayName",   "Toggle Walking State with Combat");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-Description",   "Disables/enables the walking state when entering/exiting combat, this should only be enabled if the movement speed are vanilla values, i.e. the walking state's speed is slow.");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-DisplayName", "Preserve Movement Speed in Scenes");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-Description", "Prevents the game from lowering your movement speed in scenes.");
    this.Text("WalkByDefault-Config-General-ModifyAmount-DisplayName",          "Modify Amount");
    this.Text("WalkByDefault-Config-General-ModifyAmount-Description",          "The amount to use when increasing/decreasing your movement speed.");

    this.Text("WalkByDefault-Config-MovementSpeed",                             "Movement Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-DisplayName",         "Walk Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-Description",         "The movement speed when the walk state is toggled (vanilla value is 1.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-DisplayName",         "Jog Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-Description",         "The movement speed for the jog state (vanilla value is 3.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-DisplayName",       "Sprint Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-Description",       "The movement speed when sprinting (vanilla value is 7.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-DisplayName",       "Crouch Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-Description",       "The movement speed when crouching (vanilla value is 1.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-DisplayName", "Crouch Sprint Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-Description", "The movement speed when crouch sprinting (vanilla value is 5.0).");
  }
}
