---@class KeyBindInfo
---@field keybindLabel string
---@field isHoldLabel string
---@field keybindDescription string
---@field isHoldDescription string
---@field id string
---@field maxKeys number
---@field maxKeysLabel string
---@field maxKeysDescription string
---@field supportsHold boolean
---@field defaultValue table
---@field value table

local holdTime = 0.5

local input = {
    listeningKeybindWidget = nil,
    inputListener = nil,
    bindings = {},
    activeKeys = {},
    nuiTables = {}
}

local function handleInput(event)
    local key = event:GetKey().value
    local action = event:GetAction().value

    if input.listeningKeybindWidget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBindingEvent has to be called manually for gamepad inputs, while there is a keybind widget listening for input
        input.listeningKeybindWidget:OnKeyBindingEvent(KeyBindingEvent.new({ keyName = key }))
        input.listeningKeybindWidget = nil
    elseif input.listeningKeybindWidget and action == "IACT_Release" then -- Key was bound, by keyboard
        input.listeningKeybindWidget = nil
    end

    if action == "IACT_Press" then
        input.activeKeys[key] = 0
    else
        input.activeKeys[key] = nil
    end
end

function input.onInit()
    Observe("SettingsSelectorControllerKeyBinding", "ListenForInput",
        function(this) -- A keybind widget is listening for input, so should we (Since gamepad inputs are not sent to the native OnKeyBindingEvent by default)
            input.listeningKeybindWidget = this
        end)

    input.inputListener = NewProxy({
        OnKeyInput = { -- https://github.com/psiberx/cp2077-codeware/wiki#game-events
            args = { 'whandle:KeyInputEvent' },
            callback = handleInput
        }
    })

    ObserveBefore("PlayerPuppet", "OnGameAttached", function()
        Game.GetCallbackSystem():UnregisterCallback("Input/Key", input.inputListener:Target())
        Game.GetCallbackSystem():RegisterCallback("Input/Key", input.inputListener:Target(),
            input.inputListener:Function("OnKeyInput"))
    end)

    ObserveBefore("PlayerPuppet", "OnDetach", function()
        Game.GetCallbackSystem():UnregisterCallback("Input/Key", input.inputListener:Target())
    end)

    Game.GetCallbackSystem():RegisterCallback("Input/Key", input.inputListener:Target(),
        input.inputListener:Function("OnKeyInput"))
end

function input.onUpdate(deltaTime)
    for key, time in pairs(input.activeKeys) do -- Update hold times
        input.activeKeys[key] = time + deltaTime
    end

    for _, binding in pairs(input.bindings) do
        local allPressed = true
        for _, keyInfo in pairs(binding.keys) do
            if not input.activeKeys[keyInfo[1]] or (input.activeKeys[keyInfo[1]] and keyInfo[2] and not (input.activeKeys[keyInfo[1]] > holdTime)) then
                allPressed = false
                break
            end
        end

        if allPressed then
            for _, key in pairs(binding.keys) do
                input.activeKeys[key[1]] = nil
            end
            binding.callback()
        end
    end
end

function input.onShutdown()
    Game.GetCallbackSystem():UnregisterCallback("Input/Key", input.inputListener:Target())
end

return input
