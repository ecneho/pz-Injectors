local Players = {}

function Players.List()
    local list = {}

    if isServer() then
        local onlinePlayers = getOnlinePlayers()

        if onlinePlayers then
            for i = 0, onlinePlayers:size() - 1 do
                table.insert(list, onlinePlayers:get(i))
            end
        end
    else
        for i = 0, getNumActivePlayers() - 1 do
            local player = getSpecificPlayer(i)

            if player and not player:isDead() then
                table.insert(list, player)
            end
        end
    end

    return list
end

function Players.Key(player)
    if isServer() then
        return player:getUsername()
    end

    return "SP" .. tostring(player:getPlayerNum())
end

return Players