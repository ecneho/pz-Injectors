if isClient() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Active = require "Injectors/Models/Active"
local Overdose = require "Injectors/Models/Overdose"
local Common = require "Injectors/Variables/Common"
local Roles = require "Injectors/Utils/Roles"
local Players = require "Injectors/Utils/Players"
local Net = require "Injectors/Utils/Net"

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "RequestEffects" then return end

    local username = Players.Key(player)

    if not Roles.hasCapability(player, "CanMedicalCheat") then
        FileLogger.Warn(string.format(
            "%s was denied effect request: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local activeEffects = Active.GetActiveList()[username] or {}

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

    Net.Reply(player, "InjectorEffectData", response)
end

Events.OnClientCommand.Add(OnClientCommand)