-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Data = require "Injectors/Utils/Data"
local Logging = require "Injectors/Utils/Logging"
local Common = require "Injectors/Variables/Common"

-- effect ticking
local function onEffectTick()
    local activeList = Data.GetActiveList()
    local onlinePlayers = getOnlinePlayers()

    if not onlinePlayers or onlinePlayers:size() == 0 then return end

    for i = 0, onlinePlayers:size() - 1 do
        local player = onlinePlayers:get(i)
        local username = player:getUsername()
        local effects = activeList[username]

        if effects and #effects > 0 then
            for j = #effects, 1, -1 do
                local effect = effects[j]

                if effect.delayLeft > 0 then
                    effect.delayLeft = effect.delayLeft - 1
                else
                    if effect.procCounter <= 0 then
                        local effectFunction = System.EffectRegistry[effect.effectId]

                        if type(effectFunction) == "function" then
                            effectFunction(player, effect.ticksLeft, effect.customArgs)
                        else
                            Logging.Info("Error: Missing function for effect ID '" .. tostring(effect.effectId) .. "'")
                        end

                        effect.procCounter = effect.procRate - 1
                    else
                        effect.procCounter = effect.procCounter - 1
                    end

                    effect.ticksLeft = effect.ticksLeft - 1

                    if effect.ticksLeft <= 0 then
                        table.remove(effects, j)
                        Logging.Info("Effect[" .. j .. "] expired for " .. username)
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

local function onOverdoseTick()
    decayTickCounter = decayTickCounter + 1

    if decayTickCounter >= Common.OVERDOSE_RATE then
        local onlinePlayers = getOnlinePlayers()

        if not onlinePlayers or onlinePlayers:size() == 0 then
            decayTickCounter = 0
            return
        end

        local overdoseList = Data.GetOverdoseList()

        for i = 0, onlinePlayers:size() - 1 do
            local player = onlinePlayers:get(i)
            local username = player:getUsername()
            local currentOverdose = overdoseList[username]

            if type(currentOverdose) == "number" and currentOverdose > 0 then
                overdoseList[username] = math.max(0, currentOverdose - Common.OVERDOSE_DECAY)

                if overdoseList[username] > Common.OVERDOSE_THRESHOLD then
                    player:getBodyDamage():ReduceGeneralHealth(999)
                end

                if overdoseList[username] == 0 then
                    overdoseList[username] = nil
                    Logging.Info("Overdose fully decayed for " .. username)
                end
            end
        end

        decayTickCounter = 0
    end
end

Events.OnTick.Add(onEffectTick)
Events.OnTick.Add(onOverdoseTick)