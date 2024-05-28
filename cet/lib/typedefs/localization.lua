--- @class MenuEntryLocalization
--- @field description string
--- @field label string

--- @class BindEntryLocalization
--- @field keybindLabel string
--- @field isHoldLabel string
--- @field keybindDescription string
--- @field isHoldDescription string
--- @field maxKeysLabel string
--- @field maxKeysDescription string

--- @class SettingsLocalization
--- @field keyboardBind BindEntryLocalization
--- @field gamepadBind BindEntryLocalization
--- @field walkingSpeed MenuEntryLocalization
--- @field joggingSpeed MenuEntryLocalization
--- @field sprintingSpeed MenuEntryLocalization
--- @field crouchSpeed MenuEntryLocalization
--- @field crouchSprintSpeed MenuEntryLocalization
--- @field persistSystem MenuEntryLocalization
--- @field toggleWalkingStateWithCombat MenuEntryLocalization

--- @class SubcategoriesLocalization
--- @field settings string
--- @field keyboardBind string
--- @field gamepadBind string

--- @class MenuLocalization
--- @field subcategories SubcategoriesLocalization
--- @field settings SettingsLocalization

--- @class ErrorsLocalization
--- @field missingCodeware string
--- @field missingNativeSettings string

--- @class Localization
--- @field modName string
--- @field errors ErrorsLocalization
--- @field menu MenuLocalization
