if isClient() then return end

local Hash = require "Injectors/Utils/Hash"
local Registry = require "Injectors/Registry"

local function GetWeightedInjector()
    -- chance sum should not exceed 100
    local injectors = {}

    for _, id in ipairs(Registry.Ids) do
        table.insert(injectors, {
            Id = Registry.GetFullType(id),
            Chance = Registry.GetSpawnWeight(id)
        })
    end

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
            if isServer() then
                sendRemoveItemFromContainer(container, item)
            end

            local replacement = GetWeightedInjector()
            if replacement then
                local newItem = instanceItem(replacement.Id)

                if newItem then
                    local itemID = newItem:getID()
                    local signed = Hash.Sign(itemID)
                    local modData = newItem:getModData()
                    modData.serverSignature = signed

                    container:DoAddItem(newItem)
                    if isServer() then
                        sendAddItemToContainer(container, newItem)
                    end
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