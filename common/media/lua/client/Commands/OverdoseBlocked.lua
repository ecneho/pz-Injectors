if isServer() then return end

local function OnServerCommand(module, command, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "OverdoseBlocked" then return end

    local player = getPlayer()
    if player then
        player:Say(getText("UI_Injectors_OverdoseBlocked"))
    end
end

Events.OnServerCommand.Add(OnServerCommand)