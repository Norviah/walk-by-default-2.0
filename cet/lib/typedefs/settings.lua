--- @class FloatSetting
--- @field value Float
--- @field defaultValue Float
--- @field min Float
--- @field max Float
--- @field step Float
--- @field tweakDBKey String

--- @class BindSetting
--- @field id string
--- @field maxKeys number
--- @field supportsHold boolean
--- @field defaultValue table
--- @field value table

--- @class BooleanSetting
--- @field value boolean
--- @field description string
--- @field label string
--- @field defaultValue boolean

--- @class Settings
--- @field keyboardBind BindSetting
--- @field gamepadBind BindSetting
--- @field walkingSpeed FloatSetting
--- @field joggingSpeed FloatSetting
--- @field sprintingSpeed FloatSetting
--- @field crouchSpeed FloatSetting
--- @field crouchSprintSpeed FloatSetting
--- @field persistSystem BooleanSetting
--- @field toggleWalkingStateWithCombat BooleanSetting
