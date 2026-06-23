local InjectorsIDs = {
    ["Injectors.injector_epinephrine"] = true,
    ["Injectors.injector_propital"] = true,
    ["Injectors.injector_hemostatic"] = true
}

local function OnInject(playerObj, item, bodyPart)
    ISTimedActionQueue.add(ISInjectMedicationAction:new(playerObj, item, bodyPart))
end

local function OnInjectContext(player, context, items)
    local playerObj = getSpecificPlayer(player)
    local injector = nil

    for _, item in ipairs(items) do
        if not instanceof(item, "InventoryItem") then
            item = item.items[1]
        end

        if InjectorsIDs[item:getFullType()] then
            injector = item
            break
        end
    end

    if injector then
        -- TODO: add locale support, getText()
        context:addOption("Inject Medication", playerObj, OnInject, injector, nil)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(OnInjectContext)