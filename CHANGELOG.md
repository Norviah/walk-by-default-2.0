## [v2.2.0](https://github.com/Norviah/walk-by-default-2.0/compare/v2.1.1...v2.2.0) (2025-03-23)

### Features

- add clothe modifier system <code>[4c4cb95](https://github.com/Norviah/walk-by-default-2.0/commit/4c4cb95756e61ac8b1753b65180c60bb386f70f4)</code>

- save a reference when modifying the player's speed stat <code>[3e33fc5](https://github.com/Norviah/walk-by-default-2.0/commit/3e33fc5a7f0f9109172e18cf59283c784bf46bb0)</code>

- added the ability to edit movement speed for swimming and fast swimming <code>[a2950ff](https://github.com/Norviah/walk-by-default-2.0/commit/a2950ff4bb41937b2f6463cdbcdc98a8855662cc)</code>

- **debug**: first infer the player's state from the property then from the blackboard <code>[b0df1f9](https://github.com/Norviah/walk-by-default-2.0/commit/b0df1f903e950156d71e73cee560a6fea2e03c21)</code>

### Bug Fixes

- reset the player's movement state when toggling the walk state <code>[88a9f29](https://github.com/Norviah/walk-by-default-2.0/commit/88a9f29f41bc305351548a8044893c7ca6a10afa)</code>

- set the player's detailed state to `Stand` when entering the walk state <code>[7ba457a](https://github.com/Norviah/walk-by-default-2.0/commit/7ba457ae6036a8d32336640745e45605693b0327)</code>

### Refactor

- restructure code into sections <code>[8687473](https://github.com/Norviah/walk-by-default-2.0/commit/8687473146c3b736b26a67a4056e46d78e614e07)</code>

## [v2.1.1](https://github.com/Norviah/walk-by-default-2.0/compare/v2.1.0...v2.1.1) (2025-03-08)

### Features

- update movement speed after leaving mod settings menu <code>[90a384b](https://github.com/Norviah/walk-by-default-2.0/commit/90a384be1c0a3810a4f8d4313e1cfa7b7222ac19)</code>

## [v2.1.0](https://github.com/Norviah/walk-by-default-2.0/compare/v2.0.0-rc1...v2.1.0) (2025-03-05)

### Features

- **translations**: add russian translation <code>[fed959c](https://github.com/Norviah/walk-by-default-2.0/commit/fed959c0169b37e6486bb24ee663b8efa62d117b)</code>

	thank you to PumpernikeL

- **translations**: add chinese translation <code>[498b58e](https://github.com/Norviah/walk-by-default-2.0/commit/498b58ecc766a4c7f1293d71439ef1d1a673161c)</code>

	thank you to TrygveHusky

- add the option to edit the movement speed for aim walking <code>[9c58459](https://github.com/Norviah/walk-by-default-2.0/commit/9c58459005000eafc69b2fb03d9f83c65c208990)</code>

- implement the ability to increase/decrease the movement speed on demand <code>[05c83b0](https://github.com/Norviah/walk-by-default-2.0/commit/05c83b0c2f13a47f3865e0dc561cd29518beb8be)</code>

- edit movement speed by modifying the player's stats directly <code>[18b28f6](https://github.com/Norviah/walk-by-default-2.0/commit/18b28f6fe1097e62998851c9d3e2d7579ddc7a77)</code>

- set the max amount for movement speed to `15.0` <code>[8653eca](https://github.com/Norviah/walk-by-default-2.0/commit/8653ecaf34fc9539143bf2aa61d965796657fdc6)</code>

- ensure that the toggled state isn't disabled when enabling it after sprinting <code>[0d6e154](https://github.com/Norviah/walk-by-default-2.0/commit/0d6e154ed6e0cd950ca1620d426954aa683d7717)</code>

## [v2.0.0-rc1](https://github.com/Norviah/walk-by-default-2.0/compare/v1.10.0...v2.0.0-rc1) (2025-01-12)

### Features

- re-write the mod in redscript with input loader <code>[3ff304e](https://github.com/Norviah/walk-by-default-2.0/commit/3ff304e61a04cfb36e30f01452a0c740b0b32e5d)</code>

### Build System

- **bump**: also include commit bodies in changelogs <code>[4698a7c](https://github.com/Norviah/walk-by-default-2.0/commit/4698a7c57300d6c4fafa6ceb8ecb834bfc5057d5)</code>

- **scripts**: update scripts and also include comments <code>[94c8053](https://github.com/Norviah/walk-by-default-2.0/commit/94c805396ed0a24a727a7eebe68a44adb9b62d51)</code>

## [v1.10.0](https://github.com/Norviah/walk-by-default-2.0/compare/v1.9.0...v1.10.0) (2024-05-28)

### Features

- **cet**: add localization <code>[fe509ed](https://github.com/Norviah/walk-by-default-2.0/commit/fe509ed41effa9573f5f0c29e8711c75d3320dc8)</code>

### Build System

- **scripts**: add a script for installing and uninstalling the mod <code>[636a0ad](https://github.com/Norviah/walk-by-default-2.0/commit/636a0ad0e6da44a1bd92ea96f2e0e60e98f391c5)</code>

## [v1.9.0](https://github.com/Norviah/walk-by-default-2.0/compare/v1.8.1...v1.9.0) (2024-05-27)

### Features

- **cet**: add a setting to edit the speed for crouch sprinting <code>[95a159e](https://github.com/Norviah/walk-by-default-2.0/commit/95a159eff1b2c9e559848d86f365886c12b653a9)</code>

## [v1.8.1](https://github.com/Norviah/walk-by-default-2.0/compare/v1.8.0...v1.8.1) (2024-05-25)

### Bug Fixes

- **cet**: ensure the custom walking state flag is reset when the player stands <code>[0d00ae7](https://github.com/Norviah/walk-by-default-2.0/commit/0d00ae786706fcca8483bcfa7a865adf8fa2a5ad)</code>

## [v1.8.0](https://github.com/Norviah/walk-by-default-2.0/compare/v.1.7.0...v1.8.0) (2024-05-20)

### Features

- **redscript**: allow the player to crouch sprint regardless if the walking state was enabled <code>[bfe30f4](https://github.com/Norviah/walk-by-default-2.0/commit/bfe30f40be41f7a447143e07102c2cdc4eb13770)</code>

## [v.1.7.0](https://github.com/Norviah/walk-by-default-2.0/compare/v1.6.1...v.1.7.0) (2024-05-17)

### Features

- **cet**: prevent the game from editing the player's movement speed when entering a scene <code>[83d8d1e](https://github.com/Norviah/walk-by-default-2.0/commit/83d8d1ea632cbed4a931c5391704501c24844b35)</code>

## [v1.6.1](https://github.com/Norviah/walk-by-default-2.0/compare/v1.6.0...v1.6.1) (2024-05-15)

### Build System

- add dummy text file so the `data` folder isn't empty <code>[c932ffc](https://github.com/Norviah/walk-by-default-2.0/commit/c932ffc978b971c73f712e96d331ed20185a8418)</code>

## [v1.6.0](https://github.com/Norviah/walk-by-default-2.0/compare/v1.5.0...v1.6.0) (2024-05-15)

### style

- **cet**: update menu labels for more context <code>[793918b](https://github.com/Norviah/walk-by-default-2.0/commit/793918be4df5e2c4b1f20f09192c6808ab2ef6fb)</code>

### Features

- **cet**: add a feature to toggle the walking state when the player's combat state changes <code>[ddb833f](https://github.com/Norviah/walk-by-default-2.0/commit/ddb833f58d7adc5069431c61ce9701d211f11d71)</code>

- **cet**: don't include default config object <code>[b58fea8](https://github.com/Norviah/walk-by-default-2.0/commit/b58fea85b8c694fdf0195429fa23977dc20af626)</code>

## [v1.5.0](https://github.com/Norviah/walk-by-default-2.0/compare/v1.5.0-rc2...v1.5.0) (2024-05-14)

### Features

- **cet**: ensure the user is not in a vehicle before toggling the walk state <code>[ae63a55](https://github.com/Norviah/walk-by-default-2.0/commit/ae63a55cd75306f9c67a518bed9370e0df8edcd8)</code>

## [v1.5.0-rc2](https://github.com/Norviah/walk-by-default-2.0/compare/v1.5.0-rc1...v1.5.0-rc2) (2024-05-13)

### Bug Fixes

- **scripts**: ensure the r6 and bin folder are in root when zipped <code>[46ad9e5](https://github.com/Norviah/walk-by-default-2.0/commit/46ad9e519af12e4de7b2df4b717c95b84b8c0119)</code>

- **scripts**: fix check that checks if mods have been imported <code>[00c5802](https://github.com/Norviah/walk-by-default-2.0/commit/00c580206923b205979d460ea01af96afd276644)</code>

### Refactor

- **redscript**: rename `Movement.reds` to `reference.reds` <code>[fac53fe](https://github.com/Norviah/walk-by-default-2.0/commit/fac53febeb00c4d6c54ad62998eef4c4c38ce45d)</code>

- **cet**: move the persist system into a script <code>[48c96c0](https://github.com/Norviah/walk-by-default-2.0/commit/48c96c0d0b3d374d8eaa5a1cf747806b36c9a9f8)</code>

### Features

- **cet**: refactor the persist system to prevent more actions from disabling the walking state <code>[6d90c6e](https://github.com/Norviah/walk-by-default-2.0/commit/6d90c6ea6f9d5f6fb30be2a7cbae19860f5ad598)</code>

- **cet**: add the ability to edit the movement speed when crouching <code>[22dcd80](https://github.com/Norviah/walk-by-default-2.0/commit/22dcd80b4be5ec5cebfd484bf9c33cdf1c4439e4)</code>

### Build System

- add bump for version management <code>[3be9cca](https://github.com/Norviah/walk-by-default-2.0/commit/3be9cca2bd04201d94193bece90b0613bb06d638)</code>

## v1.5.0-rc1 (2024-05-12)