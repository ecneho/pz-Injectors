-- server only
if not isServer() then return end

local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "DumpInventoryIDs" then
        if not player then return end

        local inventory = player:getInventory()
        if not inventory then return end

        local items = inventory:getItems()
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            if item then
                local fullType = item:getFullType()
                local name = item:getName()
                local id = item:getID()
                Logging.Info("Inventory Item: " .. name .. ", Type: " .. fullType .. ", ID: " .. id)
            end
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)