module WalkByDefault.Localization.Packages

import Codeware.Localization.*

public class Russian extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("WalkByDefault-Title", "Walk By Default 2.0");

    this.Text("WalkByDefault-Config-General",                                   "ОБЩИЕ");
    this.Text("WalkByDefault-Config-General-Enable-DisplayName",                "Включить");
    this.Text("WalkByDefault-Config-General-Enable-Description",                "Активирует модификацию.");
    this.Text("WalkByDefault-Config-General-PersistSystem-DisplayName",         "Уверенная походка");
    this.Text("WalkByDefault-Config-General-PersistSystem-Description",         "Предотвращает самовольное отключение режима ходьбы игрой.");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-DisplayName",   "Переключение режима передвижения при вступлении/выходе из боя");
    this.Text("WalkByDefault-Config-General-ToggleStateInCombat-Description",   "Переключает режим ходьбы в зависимости от игровой ситуации: когда персонаж вступает в бой и выходит из него.\nНеобходимо включить только в случае, когда скорость в режиме «Ходьба» выставлена на ванильное значение.");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-DisplayName", "Сохранять скорость передвижения");
    this.Text("WalkByDefault-Config-General-PreserveSpeedInScenes-Description", "Не позволяет игре снижать скорость передвижения персонажа в сценах.");
    this.Text("WalkByDefault-Config-General-ModifyAmount-DisplayName",          "Modify Amount");
    this.Text("WalkByDefault-Config-General-ModifyAmount-Description",          "The amount to use when increasing/decreasing your movement speed.");

    this.Text("WalkByDefault-Config-MovementSpeed",                             "СКОРОСТЬ В РЕЖИМАХ ПЕРЕДВИЖЕНИЯ");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-DisplayName",         "Ходьба");
    this.Text("WalkByDefault-Config-MovementSpeed-Walking-Description",         "Скорость передвижения при ходьбе (ванильное значение: 1,5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-DisplayName",         "Пробежка");
    this.Text("WalkByDefault-Config-MovementSpeed-Jogging-Description",         "Скорость передвижения при пробежке (ванильное значение: 3.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-DisplayName",       "Ускорение");
    this.Text("WalkByDefault-Config-MovementSpeed-Sprinting-Description",       "Скорость передвижения при ускорении (ванильное значение: 7.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-AimWalking-DisplayName",      "Aim Walk Speed");
    this.Text("WalkByDefault-Config-MovementSpeed-AimWalking-Description",      "The movement speed while aiming and scanning (vanilla value is 1.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-DisplayName",       "Присед");
    this.Text("WalkByDefault-Config-MovementSpeed-Crouching-Description",       "Скорость передвижения в приседе (ванильное значение: 1.5).");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-DisplayName", "Скрытное ускорение");
    this.Text("WalkByDefault-Config-MovementSpeed-CrouchSprinting-Description", "Скорость передвижения при скрытном ускорении (ванильное значение: 5.0).");
    this.Text("WalkByDefault-Config-MovementSpeed-Swimming-DisplayName",        "Swimming");
    this.Text("WalkByDefault-Config-MovementSpeed-Swimming-Description",        "The movement speed when swimming (vanilla value is 1.0).");
    this.Text("WalkByDefault-Config-MovementSpeed-FastSwimming-DisplayName",    "Fast Swimming");
    this.Text("WalkByDefault-Config-MovementSpeed-FastSwimming-Description",    "The movement speed when fast swimming (vanilla value is 1.5).");
  }
}
