require "luautils"

local Injectable = {
    ["Injectors.injector_red"] = true,
    ["Injectors.injector_blue"] = true,
    ["Injectors.injector_green"] = true
}

local function isInjectable(item)
    return Injectable[item:getFullType()]
end

local function OnInject(playerObj, item)
    if luautils.haveToBeTransfered(playerObj, item) then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()))
    end

    if not playerObj:isHandItem(item) then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, item, SandboxVars.Injectors.GLOBAL_INJECTOR_EQUIP_SPEED, true, false))
    end

    ISTimedActionQueue.add(ISInjectMedicationAction:new(playerObj, item))
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