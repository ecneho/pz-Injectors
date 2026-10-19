if isClient() then return end

local Active = {}

function Active.GetActiveList()
    return ModData.getOrCreate("Injectors_ActiveList")
end

return Active