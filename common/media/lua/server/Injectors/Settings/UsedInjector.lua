-- server only
if not isServer() then return end

local Injectors = require "Injectors/Models/Injectors"
local Handlers = require "Injectors/Models/Handlers"
local FileLogger = require "Injectors/Utils/FileLogger"
local hash = require "Injectors/Utils/Hash"

local Settings = {}

---@param player IsoPlayer
---@param item InventoryItem|nil
---@param id string
function Settings.Used(player, item, id)
    if not player then
        FileLogger.Warn(string.format(
            "Injector '%s' could not be used: missing player.", tostring(id)
        ))
        return false
    end

    if not item then
        FileLogger.Warn(string.format(
            "%s is using injector '%s', but the item reference is nil.",
            FileLogger.FormatPlayer(player), tostring(id)
        ))
    else
        local modData = item:getModData()
        local itemID = item:getID()
        local itemSignature = (modData and modData.serverSignature) and modData.serverSignature or "none"
        local generatedSignature = hash.Sign(itemID)

        if not hash.Verify(itemID, itemSignature) then
            FileLogger.Warn(string.format(
                "Injector signature does not match. Player: %s, ItemID: %s, Expected: %s, Received: %s",
                FileLogger.FormatPlayer(player), tostring(itemID), tostring(generatedSignature), tostring(itemSignature)
            ))
        else
            FileLogger.Info(string.format("Injector signature matched for ID: %s", tostring(itemID)))
        end
    end

    if not id and item then
        id = item:getType()
    end

    if not id then
        FileLogger.Warn(string.format(
            "%s attempted to use an injector, but no ID is present.",
            FileLogger.FormatPlayer(player)
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