-- client only
if not isClient() then return end

-- shouldn't load for now
if true then return end

local function OnReceiveDeepWoundsCommand(module, command, args)
    if module ~= "InjectorsModule" or command ~= "ServerApplyDeepWounds" then
        return
    end

    print("received server command: ServerApplyDeepWounds")

    local player = getPlayerByOnlineID(args.playerId)
    if not player then return end

    local bodyDamage = player:getBodyDamage()

    for _, partType in ipairs(args.bodyParts or {}) do
        local part = bodyDamage:getBodyPart(partType)
        if part then
            part:setDeepWounded(true)
        end
    end
end

Events.OnServerCommand.Add(OnReceiveDeepWoundsCommand)