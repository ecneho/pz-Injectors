-- server only
if not isServer() then return end

local Data = require "Injectors/Utils/Data"
local Overdose = require "Injectors/Models/Overdose"
local Common = require "Injectors/Variables/Common"
local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "RequestEffects" then return end

    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        Logging.Warning(username .. " denied effect request: missing CanMedicalCheat capability")
        return
    end

    local activeEffects = Data.GetActiveList()[username] or {}

    local response = {
        overdoseLevel = Overdose.Get(username),
        maxOverdose = Common.OVERDOSE_THRESHOLD,
        effects = {}
    }

    for _, effect in ipairs(activeEffects) do
        response.effects[#response.effects + 1] = {
            delay = effect.delay,
            duration = effect.duration,
            rate = effect.rate,
            effectId = effect.effectId,
            ticksLeft = effect.ticksLeft,
            delayLeft = effect.delayLeft,
        }
    end

    sendServerCommand(player, "InjectorsModule", "InjectorEffectData", response)
end

Events.OnClientCommand.Add(OnClientCommand)