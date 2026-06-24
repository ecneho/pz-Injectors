-- server only
if not isServer() then return end

local hash = require "Injectors/Utils/Hash"

local UsedEpinephrine = require "Injectors/Settings/UsedEpinephrine"

local Container = {}

---@param player IsoPlayer
function Container.Apply(player)
    if not player then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local item = inventory:getFirstTypeRecurse("Injectors.injector_epinephrine")

    if item then
        local modData = item:getModData()
        local itemID = item:getID()

        local itemSignature = modData.serverSignature or "none"
        local generatedSignature = hash.Sign(itemID)

        print("Found injector. ID: " .. itemID)
        print("Expected: " .. generatedSignature)
        print("Received: " .. itemSignature)

        if hash.Verify(itemID, itemSignature) then
            print("Injector signature does match.")
        else
            print("!! Injector signature does not match !!")
        end

        UsedEpinephrine.Used(player)
        inventory:DoRemoveItem(item)
    else
        print("No injector_epinephrine found in the inventory.")
    end
end

return Container