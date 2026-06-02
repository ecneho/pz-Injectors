local dummy = "injectorItems.injector_empty"
local myDistribution = {
    MedicalCabinet = {
        items = { dummy, 5 }
    },
    HospitalRoomCounter = {
        items = { dummy, 5 }
    },
    HospitalRoomShelves = {
        items = { dummy, 5 }
    },
    MedicalStorageOutfit = {
        items = { dummy, 5 }
    },
    MedicalStorageTools = {
        items = { dummy, 5 }
    },
    BinHospital = {
        items = { dummy, 5 }
    },
    HospitalLockers = {
        items = { dummy, 5 }
    },
    MedicalClinicTools = {
        items = { dummy, 5 }
    },
    MedicalClinicDrugs = {
        items = { dummy, 5 }
    }
}

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