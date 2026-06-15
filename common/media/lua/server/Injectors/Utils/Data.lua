-- server only
if not isServer() then return end

local Data = {}

-- tables are cached for performance:
--- @type table|nil
local activeList = nil

--- @type table|nil
local overdoseList = nil

function Data.GetActiveList()
    if not activeList then
        activeList = ModData.getOrCreate("Injectors_ActiveList")
    end

    return activeList
end

function Data.GetOverdoseList()
    if not overdoseList then
        overdoseList = ModData.getOrCreate("Injectors_OverdoseList")
    end

    return overdoseList
end

return Data