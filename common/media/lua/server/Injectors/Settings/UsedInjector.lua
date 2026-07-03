-- server only
if not isServer() then return end

local Injectors = require "Injectors/Models/Injectors"
local Handlers = require "Injectors/Models/Handlers"
local FileLogger = require "Injectors/Utils/FileLogger"

local Settings = {}

---@param player IsoPlayer
---@param id string
function Settings.Used(player, id)
    if not player then
        FileLogger.Warn(string.format(
            "Injector '%s' could not be used: missing player.", id
        ))
        return false
    end

    local injector = Injectors.Get(id)
    if not injector then
        FileLogger.Warn(string.format(
            "%s attempted to use unknown injector '%s'.",
            FileLogger.FormatPlayer(player), id
        ))
        return false
    end

    local effects = injector.Effects
    if not effects then
        FileLogger.Warn(string.format(
            "Injector '%s' used by %s has no effects defined.",
            id, FileLogger.FormatPlayer(player)
        ))
        return false
    end

    FileLogger.Info(string.format(
        "%s used injector '%s'.",
        FileLogger.FormatPlayer(player), id
    ))

    for name, data in pairs(effects) do
        local handler = Handlers[name]

        if handler then
            FileLogger.Info(string.format(
                "Applying effect '%s' from injector '%s' to %s.",
                name, id, FileLogger.FormatPlayer(player)
            ))

            handler(player, data)
        else
            FileLogger.Warn(string.format(
                "Injector '%s' references unknown effect handler '%s'.",
                id, name
            ))
        end
    end

    return true
end

return Settings