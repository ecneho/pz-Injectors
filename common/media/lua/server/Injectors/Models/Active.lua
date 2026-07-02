-- server only
if not isServer() then return end

local Active = {}

-- tables are cached for performance:
--- @type table|nil
local activeList = nil

function Active.GetActiveList()
    if not activeList then
        activeList = ModData.getOrCreate("Injectors_ActiveList")
    end

    return activeList
end

return Active