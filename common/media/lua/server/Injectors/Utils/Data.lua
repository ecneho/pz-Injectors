-- server only
if not isServer() then return end

local Data = {}

--- @type table|nil
local activeList -- cached for performance

function Data.GetActiveList()
    if not activeList then
        activeList = ModData.getOrCreate("Injectors_ActiveList")
    end

    return activeList
end

return Data