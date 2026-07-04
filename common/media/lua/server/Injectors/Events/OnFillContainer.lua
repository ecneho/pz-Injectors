-- server only
if not isServer() then return end

local hash = require "Injectors/Utils/Hash"

local injectors = {
    { Id = "Injectors.injector_red" },
    { Id = "Injectors.injector_blue" },
    { Id = "Injectors.injector_green" }
}

---@param container ItemContainer
local function ReplaceDummies(container)
    if not container then return end

    print("SPAWN PROCEDURE #2")

    local items = container:getItems()

    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)

        print("SPAWN PROCEDURE #3")

        if item and item:getFullType() == "Injectors.injector_empty" then
            container:DoRemoveItem(item)
            sendRemoveItemFromContainer(container, item)

            print("SPAWN PROCEDURE #4")

            local replacement = injectors[ZombRand(#injectors) + 1]
            local newItem = instanceItem(replacement.Id)

            if newItem then
                local itemID = newItem:getID()
                local signed = hash.Sign(itemID)
                local modData = newItem:getModData()
                modData.serverSignature = signed

                print("SPAWN PROCEDURE #5")

                container:DoAddItem(newItem)
                sendAddItemToContainer(container, newItem)
            end
        end
    end
end

--- @param roomType string
--- @param containerType string
--- @param container ItemContainer
local function SpawnProcedure(roomType, containerType, container)
    print("SPAWN PROCEDURE #1")
    ReplaceDummies(container)
end

Events.OnFillContainer.Add(SpawnProcedure)