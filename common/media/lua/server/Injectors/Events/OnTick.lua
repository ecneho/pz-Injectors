if isClient() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local System = require "Injectors/System"
local Active = require "Injectors/Models/Active"
local Common = require "Injectors/Variables/Common"
local Overdose = require "Injectors/Models/Overdose"
local Players = require "Injectors/Utils/Players"
local Time = require "Injectors/Utils/Time"

local MAX_PROCS_PER_TICK = 120

-- effect ticking
local function onEffectTick()
    local step = Time.Step()
    local activeList = Active.GetActiveList()
    local players = Players.List()

    if #players == 0 then return end

    for _, player in ipairs(players) do
        local username = Players.Key(player)
        local effects = activeList[username]

        if effects and #effects > 0 then
            for j = #effects, 1, -1 do
                local effect = effects[j]
                local remaining = step

                if effect.delayLeft > 0 then
                    local waited = math.min(effect.delayLeft, remaining)
                    effect.delayLeft = effect.delayLeft - waited
                    remaining = remaining - waited
                end

                if effect.delayLeft <= 0 and remaining > 0 then
                    local before = effect.duration - effect.ticksLeft
                    local used = math.min(effect.ticksLeft, remaining)

                    effect.ticksLeft = effect.ticksLeft - used

                    local procs = math.ceil((before + used) / effect.rate) - math.ceil(before / effect.rate)
                    local effectFunction = System.EffectRegistry[effect.effectId]

                    for _ = 1, math.min(procs, MAX_PROCS_PER_TICK) do
                        if type(effectFunction) == "function" then
                            effectFunction(player, effect.ticksLeft, effect.customArgs)
                        else
                            FileLogger.Error(string.format(
                                "Effect [%s] has no registered function. Unable to apply effect.",
                                effect.effectId
                            ))
                            break
                        end
                    end

                    if effect.ticksLeft <= 0.000001 then
                        table.remove(effects, j)
                        FileLogger.Info(string.format(
                            "Effect [%d] has expired for character %s.",
                            j, FileLogger.FormatPlayer(player)
                        ))
                    end
                end
            end

            if #effects == 0 then
                activeList[username] = nil
            end
        end
    end
end

local decayTickCounter = 0

--- TODO: overdose % rework
local function onOverdoseTick()
    decayTickCounter = decayTickCounter + Time.Step()

    if decayTickCounter < Common.OVERDOSE_RATE then
        return
    end

    local players = Players.List()

    if #players == 0 then
        decayTickCounter = 0
        return
    end

    for _, player in ipairs(players) do
        local username = Players.Key(player)
        local current = Overdose.Get(username)

        if current > 0 then
            local next = math.max(0, current - Common.OVERDOSE_DECAY)

            if next == 0 then
                FileLogger.Info(string.format(
                    "Character %s overdose has fully decayed.",
                    FileLogger.FormatPlayer(player)
                ))
                Overdose.Clear(username)
            else
                Overdose.Set(username, next)
            end

            if next >= Common.OVERDOSE_THRESHOLD then
                if Common.OVERDOSE_DEATH_ENABLED then
                    FileLogger.Info(string.format(
                        "Character %s overdose has exceeded threshold.",
                        FileLogger.FormatPlayer(player)
                    ))

                    player:getBodyDamage():ReduceGeneralHealth(999)
                end
            end
        end
    end

    decayTickCounter = 0
end

Events.OnTick.Add(onEffectTick)
Events.OnTick.Add(onOverdoseTick)