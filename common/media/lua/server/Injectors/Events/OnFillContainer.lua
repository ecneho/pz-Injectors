-- server only
if not isServer() then return end

local Hash = require "Injectors/Utils/Hash"

local function GetWeightedInjector()
    -- chance sum should not exceed 100
    local injectors = {
        { Id = "Injectors.injector_red",   Chance = SandboxVars.Injectors.GLOBAL_RED_INJECTOR_SPAWN_WEIGHT },
        { Id = "Injectors.injector_blue",  Chance = SandboxVars.Injectors.GLOBAL_BLUE_INJECTOR_SPAWN_WEIGHT },
        { Id = "Injectors.injector_green", Chance = SandboxVars.Injectors.GLOBAL_GREEN_INJECTOR_SPAWN_WEIGHT }
    }

    local roll = ZombRand(100) + 1
    local cumulative = 0

    for i = 1, #injectors do
        cumulative = cumulative + injectors[i].Chance
        if roll <= cumulative then
            print("injectors: " .. injectors[i].Id .. " is spawned")
            return injectors[i]
        end
    end

    print("injectors: no injector is spawned")
    return nil
end

---@param container ItemContainer
local function ReplaceDummies(container)
    if not container then return end

    local items = container:getItems()

    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)

        if item and item:getFullType() == "Injectors.injector_empty" then
            print("injectors: trying to spawn an injector...")

            container:DoRemoveItem(item)
            sendRemoveItemFromContainer(container, item)

            local replacement = GetWeightedInjector()
            if replacement then
                local newItem = instanceItem(replacement.Id)

                if newItem then
                    local itemID = newItem:getID()
                    local signed = Hash.Sign(itemID)
                    local modData = newItem:getModData()
                    modData.serverSignature = signed

                    container:DoAddItem(newItem)
                    sendAddItemToContainer(container, newItem)
                end
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