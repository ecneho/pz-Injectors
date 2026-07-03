local Injectable = {
    ["Injectors.injector_red"] = true,
    ["Injectors.injector_blue"] = true,
    ["Injectors.injector_green"] = true
}

local function isInjectable(item)
    return Injectable[item:getFullType()]
end

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

        if isInjectable(item) then
            injector = item
            break
        end
    end

    if injector then
        context:addOption(getText("ContextMenu_InjectMedication"), playerObj, OnInject, injector, nil)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(OnInjectContext)