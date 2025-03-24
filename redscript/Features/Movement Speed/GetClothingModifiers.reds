module WalkByDefault.MovementSpeed

import WalkByDefault.Core.MovementState


// Here is the main function you can use to define your clothing modifiers. Each
// modifier must have these properties:
//
//   - name (String): The name of the clothe that the modifier is applied to,
//     which is determined by using a substring method. For example, if the name
//     of the modifier is "heels", then ANY clothing with "heels" (case-insensitive)
//     in its name will have the modifier applied to it.
//
//   - modifier type (gameStatModifierType): The specific type of modifier to
//     apply to the player. The available options are:
//       - gameStatModifierType.Additive: The modifier will be added to the
//         existing value of the stat.
//       - gameStatModifierType.AdditiveMultiplier: The player's speed stat will
//         be added with whatever is the result of (speed stat * modifier value).
//       - gameStatModifierType.Multiplier: The player's speed stat will be
//         multiplied by the modifier value.
//
//   - value (float): The value of the modifier, can be negative.
//
//   - movement states (array<MovementState>): An array of movement states that
//     the modifier should be applied to. If the player is not in one of these
//     states, the modifier will not be applied. The available options are:
//       - MovementState.Jogging
//       - MovementState.Walking
//       - MovementState.Sprinting
//       - MovementState.Crouching
//       - MovementState.CrouchSprinting
//       - MovementState.AimWalking
//       - MovementState.Swimming
//       - MovementState.FastSwimming
//   
//     You can put as many states as you want. These options are from the file
//     "WalkByDefault2.0/Core/MovementState.reds", everything there are the
//     supported states (except for Unknown).
//
// For example, there already is a definition for heels, which will decrease the
// player's movement by 25% when sprinting with a pair of heels.

// If you want to check the modifiers for your current movement state, you can
// press "backspace" (by default) on your keyboard. If you have CET installed,
// open the "Game Log" tab and the modifiers will be printed there, for example:
//
//   state: Sprint
//   max speed: 7.500000
//   stat type: MaxSpeed
//   value: 5.906244
//     - modifier: Additive | value: 0.000000
//     - modifier: Additive | value: 7.500000
//     - modifier: Multiplier | value: 0.750000
//
// The above example is what's printed when the player is sprinting with heels on.
// If you want to add a new modifier, feel free to copy and paste the example for
// heels (line 94-99), and change the values to your liking, but make sure to add a
// comma at the end of the previous modifier. As an example, the next modifier would
// look like this:
//
//    return [
//      ClothingModifier.Initialize(
//        "heels",
//        gameStatModifierType.Multiplier,
//        0.75,
//        [MovementState.Sprinting, MovementState.CrouchSprinting]
//      ),
//  
//      ClothingModifier.Initialize(
//        "sport",
//        gameStatModifierType.Multiplier,
//        1.25,
//        [MovementState.Sprinting, MovementState.CrouchSprinting]
//      )
//    ]

// Additionally, you can edit this file whenever you want but in order to see 
// any changes take effect, you either need to restart the game or reload scripts
// by using Red Hot Tools in CET.
//
// To install Red Hot Tools, follow these steps:
//
//   - 1. Go to: https://github.com/psiberx/cp2077-red-hot-tools 
//   - 2. Complete steps 1-3 in the install instructions
//
// If it's installed correctly, in CET, there should now be a "Hot Reload" window,
// go to the scripts tab (you may have to click the three dots in the top right
// corner and click "Hot Reload") and then click the "Reload Scripts" button (after
// you have saved this file). Then your changes should take effect.

public abstract static final func GetClothingModifiers() -> array<ref<ClothingModifier>> {
  return [
    ClothingModifier.Initialize(
      "heels",
      gameStatModifierType.Multiplier,
      0.75,
      [MovementState.Sprinting, MovementState.CrouchSprinting]
    )
  ];
}