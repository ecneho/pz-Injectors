-- server only
if not isServer() then return end

local System = require "Injectors/System"

local function OnHungerTick(player, ticksLeft, args)
    -- player:getStats():setHunger(player:getStats():getHunger() - args.amount)
    print("placeholder")
end

System.RegisterEffect("ChangeHungerEffect", OnHungerTick)

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "ChangeHunger" then

        local effectArgs = { amount = 0.05 }

        System.AddPlayerEffect(player:getUsername(), "ChangeHungerEffect", 3000, 10, 10, effectArgs)
    end
end

Events.OnClientCommand.Add(OnClientCommand)