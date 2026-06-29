-- server only
if not isServer() then return end

local Data = require "Injectors/Utils/Data"

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "RequestInjectorEffectData" then return end

    print("RequestInjectorEffectData")

    local username = player:getUsername()

    local activeEffects = Data.GetActiveList()[username] or {}

    local response = {
        overdoseLevel = 0,
        maxOverdose = 0,
        effects = {}
    }

    for _, effect in ipairs(activeEffects) do
        response.effects[#response.effects + 1] = {
            delay = effect.delay,
            duration = effect.duration,
            effectId = effect.effectId,
            ticksLeft = effect.ticksLeft,
            delayLeft = effect.delayLeft,
            procRate = effect.procRate,
        }
    end

    print("sending...")

    sendServerCommand(player, "InjectorsModule", "InjectorEffectData", response)
end

Events.OnClientCommand.Add(OnClientCommand)