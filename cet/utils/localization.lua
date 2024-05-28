local GameSettings = require("lib/GameSettings")
local localization = {}

--- @return string
function localization.GetLanguageCode()
  local code = GameSettings.Get("/language/OnScreen")

  if code ~= nil then
    return NameToString(code)
  else
    return "en-us"
  end
end

--- @return Localization
function localization.GetLocalization()
  local code = localization.GetLanguageCode()
  local file = loadfile("localizations/" .. code .. ".lua")

  if file ~= nil then
    return file()
  else
    return require("localizations/en-us.lua")
  end
end

return localization
