-- server only
if not isServer() then return end

local Data = {}

function Data.GetActiveList()
    return ModData.getOrCreate("Injectors_ActiveList")
end

return Data