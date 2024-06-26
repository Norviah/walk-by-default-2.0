local inputManager = require("utils/inputManager")
local settings = require("utils/settings")

local menu = {}

--- @param nativeSettingsPath string
--- @param info BindSetting
--- @param localization BindEntryLocalization
--- @param updateCallback function
--- @param index number
--- @param nativeSettings table
local function addKeybind(nativeSettingsPath, info, localization, updateCallback, index, nativeSettings) -- Add single keybind widget
  local numberText = info.maxKeys ~= 1 and " " .. index or ""
  local holdID = info.id .. "_hold_" .. index
  local numID = info.id .. "_" .. index

  if not info.value[numID] then info.value[numID] = info.defaultValue[numID] end
  if not info.value[holdID] then info.value[holdID] = info.defaultValue[holdID] end

  inputManager.bindings[info.id]["keys"][index] = {
    [1] = info.value[numID], -- Key code
    [2] = info.value[holdID] -- Is hold
  }

  if info.supportsHold then
    inputManager.nuiTables[holdID] = nativeSettings.addSwitch(nativeSettingsPath, localization.isHoldLabel .. numberText,
      localization.isHoldDescription, info.value[holdID], info.defaultValue[holdID], function(state)
        inputManager.nuiTables[numID].isHold =
            state                                                                                    -- Update isHold value for nui
        nativeSettings.setOption(inputManager.nuiTables[numID], inputManager.nuiTables[numID].value) -- Force update to see change visually
        inputManager.bindings[info.id]["keys"][index][2] = state
        updateCallback(holdID, state)
      end)
  end

  inputManager.nuiTables[numID] = nativeSettings.addKeyBinding(nativeSettingsPath,
    localization.keybindLabel .. numberText,
    localization.keybindDescription, info.value[numID], info.defaultValue[numID], info.value[holdID],
    function(key)
      inputManager.bindings[info.id]["keys"][index][1] = key
      updateCallback(numID, key)
    end)
end

---@param nativeSettingsPath string
---@param info BindSetting
---@param localization BindEntryLocalization
---@param updateCallback function
---@param callback function
local function addNativeSettingsBinding(nativeSettingsPath, info, localization, updateCallback, callback) -- Add combined hotkey widget from info table
  local nativeSettings = GetMod("nativeSettings")

  if not nativeSettings.pathExists(nativeSettingsPath) then
    print("[InputManager] Invalid path for binding \"" .. info.id .. "\"")
    return
  end
  if not info.value then info.value = info.defaultValue end           -- Fallback to default options
  inputManager.bindings[info.id] = { callback = callback, keys = {} } -- Binding information contains callback and keys with hold+key data

  local maxID = info.id .. "_keys"
  if not info.value[maxID] then info.value[maxID] = info.defaultValue[maxID] end

  if info.maxKeys ~= 1 then -- Add slider to change amount of key widgets
    nativeSettings.addRangeInt(nativeSettingsPath, localization.maxKeysLabel, localization.maxKeysDescription, 1,
      info.maxKeys,
      1, info.value[maxID], info.defaultValue[maxID], function(value)
        updateCallback(maxID, value)

        for i = value + 1, info.maxKeys do -- Remove keys
          if inputManager.nuiTables[info.id .. "_" .. i] then
            nativeSettings.removeOption(inputManager.nuiTables[info.id .. "_" .. i])
            inputManager.nuiTables[info.id .. "_" .. i] = nil
            inputManager.bindings[info.id]["keys"][i] = nil

            if inputManager.nuiTables[info.id .. "_hold_" .. i] then
              nativeSettings.removeOption(inputManager.nuiTables[info.id .. "_hold_" .. i])
              inputManager.nuiTables[info.id .. "_hold_" .. i] = nil
            end
          end
        end

        for i = 1, value do -- Add keys
          if not inputManager.nuiTables[info.id .. "_" .. i] then
            addKeybind(nativeSettingsPath, info, localization, updateCallback, i, nativeSettings)
          end
        end
      end)
  end

  for i = 1, info.value[maxID] do
    addKeybind(nativeSettingsPath, info, localization, updateCallback, i, nativeSettings)
  end
end

local function ToggleWalkInput()
  local inVehicle = VehicleComponent.IsMountedToVehicle(Game.GetPlayer())

  if not inVehicle then
    Game.GetPlayer():ProcessToggleWalkInput()
  end
end

--- @param localization Localization
function menu.setup(localization)
  local nativeSettings = GetMod("nativeSettings")

  if not nativeSettings then
    print("[" .. localization.modName .. "] " .. localization.errors.missingNativeSettings)
    return
  end

  local path = "/walk_by_default_2"

  nativeSettings.addTab(path, localization.modName)

  -- Parameters: (path, label, optionalIndex)

  local settingsSubcategory = path .. "/settings"
  nativeSettings.addSubcategory(settingsSubcategory, localization.menu.subcategories.settings)

  -- Parameters: path, label, desc, min, max, step, format, currentValue, defaultValue, callback, optionalIndex

  nativeSettings.addRangeFloat(
    settingsSubcategory,
    localization.menu.settings.walkingSpeed.label,
    localization.menu.settings.walkingSpeed.description,
    settings.walkingSpeed.min,
    settings.walkingSpeed.max,
    settings.walkingSpeed.step,
    "%.2f",
    settings.walkingSpeed.value,
    settings.walkingSpeed.defaultValue,
    function(value)
      settings.walkingSpeed.value = value
    end
  )

  nativeSettings.addRangeFloat(
    settingsSubcategory,
    localization.menu.settings.joggingSpeed.label,
    localization.menu.settings.joggingSpeed.description,
    settings.joggingSpeed.min,
    settings.joggingSpeed.max,
    settings.joggingSpeed.step,
    "%.2f",
    settings.joggingSpeed.value,
    settings.joggingSpeed.defaultValue,
    function(value)
      settings.joggingSpeed.value = value
    end
  )

  nativeSettings.addRangeFloat(
    settingsSubcategory,
    localization.menu.settings.sprintingSpeed.label,
    localization.menu.settings.sprintingSpeed.description,
    settings.sprintingSpeed.min,
    settings.sprintingSpeed.max,
    settings.sprintingSpeed.step,
    "%.2f",
    settings.sprintingSpeed.value,
    settings.sprintingSpeed.defaultValue,
    function(value)
      settings.sprintingSpeed.value = value
    end
  )

  nativeSettings.addRangeFloat(
    settingsSubcategory,
    localization.menu.settings.crouchSpeed.label,
    localization.menu.settings.crouchSpeed.description,
    settings.crouchSpeed.min,
    settings.crouchSpeed.max,
    settings.crouchSpeed.step,
    "%.2f",
    settings.crouchSpeed.value,
    settings.crouchSpeed.defaultValue,
    function(value)
      settings.crouchSpeed.value = value
    end
  )

  nativeSettings.addRangeFloat(
    settingsSubcategory,
    localization.menu.settings.crouchSprintSpeed.label,
    localization.menu.settings.crouchSprintSpeed.description,
    settings.crouchSprintSpeed.min,
    settings.crouchSprintSpeed.max,
    settings.crouchSprintSpeed.step,
    "%.2f",
    settings.crouchSprintSpeed.value,
    settings.crouchSprintSpeed.defaultValue,
    function(value)
      settings.crouchSprintSpeed.value = value
    end
  )

  -- Parameters: path, label, desc, currentValue, defaultValue, callback, optionalIndex

  nativeSettings.addSwitch(
    settingsSubcategory,
    localization.menu.settings.persistSystem.label,
    localization.menu.settings.persistSystem.description,
    settings.persistSystem.value,
    settings.persistSystem.defaultValue,
    function(value)
      settings.persistSystem.value = value
    end
  )

  nativeSettings.addSwitch(
    settingsSubcategory,
    localization.menu.settings.toggleWalkingStateWithCombat.label,
    localization.menu.settings.toggleWalkingStateWithCombat.description,
    settings.toggleWalkingStateWithCombat.value,
    settings.toggleWalkingStateWithCombat.defaultValue,
    function(value)
      settings.toggleWalkingStateWithCombat.value = value
    end
  )

  -- Keyboard

  local keyboardSubcategory = path .. "/keyboard"
  nativeSettings.addSubcategory(keyboardSubcategory, localization.menu.subcategories.keyboardBind)

  addNativeSettingsBinding(
    keyboardSubcategory,
    settings.keyboardBind,
    localization.menu.settings.keyboardBind,
    function(name, value)
      settings.keyboardBind.value[name] = value
    end,
    ToggleWalkInput
  )

  -- Gamepad

  local gamepadSubcategory = path .. "/gamepad"
  nativeSettings.addSubcategory(gamepadSubcategory, localization.menu.subcategories.gamepadBind)

  addNativeSettingsBinding(
    gamepadSubcategory,
    settings.gamepadBind,
    localization.menu.settings.gamepadBind,
    function(name, value)
      settings.gamepadBind.value[name] = value
    end,
    ToggleWalkInput
  )
end

return menu
