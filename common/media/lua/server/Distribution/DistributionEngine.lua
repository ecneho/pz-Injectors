-- server only
if not isServer() then return end

local hash = require "Injectors/Utils/Hash"

local injectors = {
    { Id = "Injectors.injector_hemostatic" },
    { Id = "Injectors.injector_epinephrine" },
    { Id = "Injectors.injector_propital" }
}

local function ReplaceDummies(container)
    if not container then return end

    local items = container:getItems()

    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)

        if item and item:getFullType() == "Injectors.injector_empty" then
            container:DoRemoveItem(item)

            local replacement = injectors[ZombRand(#injectors) + 1]
            local spawned = container:AddItem(replacement.Id)

            if spawned then
                local itemID = spawned:getID()
                local signed = hash.Sign(itemID)
                local modData = spawned:getModData()

                modData.serverSignature = signed
            end
        end
    end
end

--- @param roomType string
--- @param containerType string
--- @param container ItemContainer
local function SpawnProcedure(roomType, containerType, container)
    ReplaceDummies(container)
end

Events.OnFillContainer.Add(SpawnProcedure)