local settings = require("modules/settings")
local config = {}

local path = "data/config.json"

--- Load settings from file.
---
--- This function attempts to find the settings file and load it, it does not
--- return the values, instead setting them in the `Settings` object.
function config.load()
  local file = io.open(path, 'r')

  if file ~= nil then
    local content = file:read("*a")
    local validJson, savedSettings = pcall(function()
      return json.decode(content)
    end)
    file:close()

    if validJson then
      for key, _ in pairs(settings) do
        if savedSettings[key] ~= nil then
          settings[key].value = savedSettings[key]
        else
          settings[key].value = settings[key].defaultValue
        end
      end
    end
  end
end

--- Saves settings to file.
---
--- The settings saved are values that the user may have changed through Native
--- Settings, the default values do not reflect the actual values.
function config.save()
  local toSave = {}

  for key, value in pairs(settings) do
    toSave[key] = value.value
  end

  local validJson, content = pcall(function()
    return json.encode(toSave)
  end)

  if validJson and content ~= nil then
    local file = io.open(path, 'w+')
    if file ~= nil then
      file:write(content)
      file:close()
    end
  end
end

return config
