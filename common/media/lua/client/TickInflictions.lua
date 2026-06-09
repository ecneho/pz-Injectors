local TICKS = 60

local function ProcessInflictions(deltaTime)
    local player = getPlayer()
    if not player or player:isDead() then return end

    local modData = player:getModData()
    local inflictions = modData.inflictions
    if not inflictions or #inflictions == 0 then return end

    for i = #inflictions, 1, -1 do
        local inf = inflictions[i]

        if inf and inf.delay ~= nil and inf.duration ~= nil then
            if inf.delay > 0 then
                inf.delay = inf.delay - deltaTime

            else
                if inf.tick == nil then
                    inf.tick = inf.rate or 1
                end

                inf.tick = inf.tick - deltaTime
                if inf.tick <= 0 then
                    ApplyEffect(inf, player)
                    inf.tick = inf.rate or 1
                end

                inf.duration = inf.duration - deltaTime
                if inf.duration <= 0 then
                    table.remove(inflictions, i)
                end
            end
        end
    end
end

local function DecayOverdose(deltaTime)
    local player = getPlayer()
    if not player or player:isDead() then return end

    local modData = player:getModData()
    modData.overdose = modData.overdose or 0

    if modData.overdose <= 0 then return end

    local decayRate = InjectorVars.OVERDOSE_DECAY
    modData.overdose = modData.overdose - (decayRate * deltaTime)

    if modData.overdose <= 0 then
        modData.overdose = 0
    end
end

local function KillOnOverdose()
    local threshold = InjectorVars.OVERDOSE_THRESHOLD
    if threshold == -1 then return end

    local player = getPlayer()
    if not player or player:isDead() then return end

    local modData = player:getModData()
    modData.overdose = modData.overdose or 0

    if modData.overdose >= threshold then
        player:Kill(player)
    end
end

local function TickProcess()
    local multiplier = getGameTime():getMultiplier()
    if multiplier <= 0 then return end

    -- not actual delta time, represents multiplied time spent per tick
    local deltaTime = multiplier / TICKS

    ProcessInflictions(deltaTime)
    DecayOverdose(deltaTime)
    KillOnOverdose()
end

Events.OnTick.Add(TickProcess)