--- B42.18 revision. TODO: implement spawn chances in sandbox vars
local injectors = {
    { Id = "injectorItems.injector_adrenaline",     Chance = 0 },
    { Id = "injectorItems.injector_ahf1",           Chance = 0 },
    { Id = "injectorItems.injector_btg2a2",         Chance = 0 },
    { Id = "injectorItems.injector_btg3",           Chance = 0 },
    { Id = "injectorItems.injector_etg",            Chance = 0 },
    { Id = "injectorItems.injector_meldonin",       Chance = 0 },
    { Id = "injectorItems.injector_morphine",       Chance = 0 },
    { Id = "injectorItems.injector_mule",           Chance = 0 },
    { Id = "injectorItems.injector_norepinephrine", Chance = 0 },
    { Id = "injectorItems.injector_obdolbos",       Chance = 0 },
    { Id = "injectorItems.injector_obdolbos2",      Chance = 0 },
    { Id = "injectorItems.injector_p22",            Chance = 0 },
    { Id = "injectorItems.injector_perfotoran",     Chance = 0 },
    { Id = "injectorItems.injector_pnb",            Chance = 0 },
    { Id = "injectorItems.injector_propital",       Chance = 0 },
    { Id = "injectorItems.injector_sj1",            Chance = 0 },
    { Id = "injectorItems.injector_sj6",            Chance = 0 },
    { Id = "injectorItems.injector_sj9",            Chance = 0 },
    { Id = "injectorItems.injector_sj12",           Chance = 0 },
    { Id = "injectorItems.injector_trimadol",       Chance = 0 },
    { Id = "injectorItems.injector_xtg",            Chance = 0 },
    { Id = "injectorItems.injector_zagustin",       Chance = 0 }
}

local function ReplaceDummies(container)
    if not container then return end

    local items = container:getItems()
    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)

        if item and item:getFullType() == "injectorItems.injector_empty" then
            container:DoRemoveItem(item)
            local replacement = injectors[ZombRand(#injectors) + 1]
            container:AddItem(replacement.Id)
        end
    end
end

--- B42.18 revision. vanilla spawning interception
--- @param roomType string
--- @param containerType string
--- @param container ItemContainer
local function SpawnProcedure(roomType, containerType, container)
    ReplaceDummies(container)
end

Events.OnFillContainer.Add(SpawnProcedure)