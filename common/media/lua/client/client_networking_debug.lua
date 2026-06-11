-- wip server compat (client-side)

---@param module string The module the command was sent with
---@param command string The command the command was sent with
---@param args table|nil The arguments table the command was sent with or nil
local function OnServerCommand(module, command, args)
    if module ~= "InjectorsModule" then return end

    if command == "DebugPong" then
        print("DEBUG [Client]: Received response from server!")

        local player = getPlayer()
        if player then
            player:Say("Server replied: " .. tostring(args.reply))
        end
    end
end

Events.OnServerCommand.Add(OnServerCommand)

local function OnPlayerMoveDebug(player)
    print("DEBUG [Client]: Player moved. Sending event...")

    local args = { message = "debug" }
    sendClientCommand("InjectorsModule", "DebugPing", args)
end

Events.OnPlayerMove.Add(OnPlayerMoveDebug)