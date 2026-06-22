-- server only
if not isServer() then return end

local Logging = require "Injectors/Utils/Logging"
local System = require "Injectors/System"
local Overdose = require "Injectors/Data/Overdose"

---@param character IsoPlayer -- *IsoGameCharacter
local function onPlayerDeath(character)
    if not instanceof(character, "IsoPlayer") then
        return
    end

    local username = character:getUsername()
    if not username then
        return
    end

    Logging.Info("Character " .. username .. " died. Clearing effects and overdose...")

    System.RemovePlayerEffect(username)
    Overdose.Clear(username)
end

Events.OnCharacterDeath.Add(onPlayerDeath)