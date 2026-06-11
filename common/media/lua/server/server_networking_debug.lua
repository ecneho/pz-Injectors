-- wip server compat (server-side)

---@param module string The module the command was sent with
---@param command string The command the command was sent with
---@param player IsoPlayer The player who sent the command
---@param args table|nil The arguments table the command was sent with or nil
local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end

    if command == "DebugPing" then
        print("DEBUG [Server]: Received ping from client")
        print("DEBUG [Server]: Sender = " .. player:getUsername())
        print("DEBUG [Server]: Message = " .. tostring(args.message))

        local replyArgs = {
            reply = "Ping received by server."
        }

        print("DEBUG [Server]: Sending pong back...")

        sendServerCommand(
            player,
            "InjectorsModule",
            "DebugPong",
            replyArgs
        )

        player:getStats():set(CharacterStat.HUNGER, 0.5)
    end
end

Events.OnClientCommand.Add(OnClientCommand)