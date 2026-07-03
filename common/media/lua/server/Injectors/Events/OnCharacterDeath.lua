-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local System = require "Injectors/System"
local Overdose = require "Injectors/Models/Overdose"

---@param character IsoPlayer -- *IsoGameCharacter
local function onPlayerDeath(character)
    if not instanceof(character, "IsoPlayer") then
        return
    end

    local username = character:getUsername()
    if not username then
        return
    end

    FileLogger.Info(string.format(
        "Character %s has died. Removing effects and overdose.",
        FileLogger.FormatPlayer(character)
    ))

    System.RemovePlayerEffect(username)
    Overdose.Set(username, 0)
end

Events.OnCharacterDeath.Add(onPlayerDeath)