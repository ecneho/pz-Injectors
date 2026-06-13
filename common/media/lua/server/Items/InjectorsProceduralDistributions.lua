local spawner = "injectorItems.injector_empty"
local myDistribution = {
    MedicalCabinet = {
        items = { spawner, 5 }
    },
    HospitalRoomCounter = {
        items = { spawner, 5 }
    },
    HospitalRoomShelves = {
        items = { spawner, 5 }
    },
    MedicalStorageOutfit = {
        items = { spawner, 5 }
    },
    MedicalStorageTools = {
        items = { spawner, 5 }
    },
    BinHospital = {
        items = { spawner, 5 }
    },
    HospitalLockers = {
        items = { spawner, 5 }
    },
    MedicalClinicTools = {
        items = { spawner, 5 }
    },
    MedicalClinicDrugs = {
        items = { spawner, 5 }
    }
}

---@diagnostic disable-next-line Undefined field `list`
local ProceduralDistributions_list = ProceduralDistributions.list
local table_insert = table.insert

local function insertInDistribution(distrib)
    for k,v in pairs(distrib) do
        local ProceduralDistributions_list_k = ProceduralDistributions_list[k]

        local items = v.items
        local ProceduralDistributions_list_k_items = ProceduralDistributions_list_k.items
        if items then
            for i = 1,#items do
                table_insert(ProceduralDistributions_list_k_items,items[i])
            end
        end
    end
end

insertInDistribution(myDistribution)