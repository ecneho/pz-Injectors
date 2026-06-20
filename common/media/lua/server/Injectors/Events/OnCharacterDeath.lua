-- server only
if not isServer() then return end

local Logging = require "Injectors/Utils/Logging"
local System = require "Injectors/System"
local Data = require "Injectors/Utils/Data"

---@param character IsoPlayer -- *IsoGameCharacter
local function onPlayerDeath(character)
    if instanceof(character, "IsoPlayer") then
        local username = character:getUsername()
        if username then
            Logging.Info("Character ".. username .." died. Clearing effects and overdose...")
            System.RemovePlayerEffect(username)

            --- TODO: Overdose class: proper getters and setters
            local overdose = Data.GetOverdoseList()
            overdose[username] = 0
        end
    end
end

Events.OnCharacterDeath.Add(onPlayerDeath)