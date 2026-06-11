if isClient() then return end

---@param module string The module the command was sent with
---@param command string The command the command was sent with
---@param player IsoPlayer The player who sent the command
---@param args table|nil The arguments table the command was sent with or nil
local function OnClientCommand(module, command, player, args)
    if module == "InjectorsModule" and command == "ChangeHunger" then

        local modData = ModData.getOrCreate("TestID")

        if args == nil then return end

        print("receiving client command")


        modData.healingTimeLeft = args.duration
        modData.healAmountPerSecond = args.healAmount

        ModData.transmit("TestID")

        --- player:getBodyDamage():getPainReductionFromMeds() - see what can be done with this

        player:getStats():set(CharacterStat.HUNGER, 0.5)
        sendPlayerStat(player, CharacterStat.HUNGER)
        sendPlayerStatsChange(player)
    end
end

Events.OnClientCommand.Add(OnClientCommand)

local function OnServerTick()
    print("server tick")
end

Events.OnTick.Add(OnServerTick)