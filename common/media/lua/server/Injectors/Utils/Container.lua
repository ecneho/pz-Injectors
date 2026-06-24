print("Container.lua")
-- server only
if not isServer() then return end

local hash = require "Injectors/Utils/Hash"

local Epinephrine = require "Injectors/Settings/UsedEpinephrine"
local Morphine = require "Injectors/Settings/UsedMorphine"
local Adrenaline = require "Injectors/Settings/UsedAdrenaline"

local Injectors = {
    epinephrine = {
        type = "Injectors.injector_epinephrine",
        handler = Epinephrine.Used,
    },

    morphine = {
        type = "Injectors.injector_morphine",
        handler = Morphine.Used,
    },

    adrenaline = {
        type = "Injectors.injector_adrenaline",
        handler = Adrenaline.Used,
    }
}

local Container = {}

---@param player IsoPlayer
---@param injector string
function Container.Apply(player, injector)
    if not player then return end

    local def = Injectors[injector]
    if not def then
        print("Unknown injector: " .. tostring(injector))
        return
    end

    local inventory = player:getInventory()
    if not inventory then return end

    local item = inventory:getFirstTypeRecurse(def.type)

    if not item then
        print("No injector found: " .. def.type)
        return
    end

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

    if def.handler then
        def.handler(player)
    end

    inventory:DoRemoveItem(item)
end

return Container