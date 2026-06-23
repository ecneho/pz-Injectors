-- server only
if not isServer() then return end

local sha2 = require "Modules/sha2"
local UsedEpinephrine = require "Injectors/Settings/UsedEpinephrine"

-- TODO: move to the cached lua file or sandbox vars
local SERVER_SECRET_KEY = "private-key"

local Container = {}

---@param player IsoPlayer
function Container.Apply(player)
    if not player then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local item = inventory:getFirstTypeRecurse("Injector.injector_epinephrine")

    if item then
        local modData = item:getModData()
        local itemID = item:getID()

        local itemSignature = modData.serverSignature
        local generatedSignature = sha2.hmac_sha256(SERVER_SECRET_KEY, itemID)

        print("Found injector. ID: " .. itemID)
        print("Expected: " .. generatedSignature)
        print("Received: " .. itemSignature)

        if itemSignature == generatedSignature then
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