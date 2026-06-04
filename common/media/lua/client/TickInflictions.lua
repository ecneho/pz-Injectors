local TICKS = 60

local function TickInflictions()
    local multiplier = getGameTime():getMultiplier()
    if multiplier <= 0 then return end

    local player = getPlayer()
    if not player or player:isDead() then return end

    local modData = player:getModData()
    local inflictions = modData.inflictions
    if not inflictions or #inflictions == 0 then return end

    for i = #inflictions, 1, -1 do
        local inf = inflictions[i]

        if inf and inf.delay ~= nil and inf.duration ~= nil then
            local step = multiplier / TICKS
            if inf.delay > 0 then
                inf.delay = inf.delay - step

            else
                if inf.tick == nil then
                    inf.tick = inf.rate or 1
                end

                inf.tick = inf.tick - step
                if inf.tick <= 0 then
                    ApplyEffect(inf, player)
                    inf.tick = inf.rate or 1
                end

                inf.duration = inf.duration - step
                if inf.duration <= 0 then
                    table.remove(inflictions, i)
                end
            end
        end
    end
end

Events.OnTick.Add(TickInflictions)