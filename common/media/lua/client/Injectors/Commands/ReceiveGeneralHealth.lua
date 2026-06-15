-- client only
if not isClient() then return end

-- shouldn't load for now
if true then return end

local function OnReceiveGeneralHealthCommand(module, command, args)
    if module ~= "InjectorsModule" or command ~= "ServerGeneralHealth" then
        return
    end

    print("received server command: ServerGeneralHealth")

    local player = getPlayerByOnlineID(args.playerId)
    if not player then return end

    local bodyDamage = player:getBodyDamage()
    local health = args.health or 0

    if (args.health > 0) then
       bodyDamage:AddGeneralHealth(health)
    end
    if (args.health < 0) then
        bodyDamage:ReduceGeneralHealth(-health)
    end
end

Events.OnServerCommand.Add(OnReceiveGeneralHealthCommand)