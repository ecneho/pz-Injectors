-- server only
if not isServer() then return end

local Injectors = {}

---@type table|nil
local injectorList = nil

local function getStorage()
    if not injectorList then
        injectorList = ModData.getOrCreate("Injectors_InjectorList")
    end

    return injectorList
end

---@param injector string
function Injectors.Get(injector)
    return getStorage()[injector]
end

---@param id string
---@param injector table
function Injectors.Set(id, injector)
    local data = getStorage()
    data[id] = injector
end

return Injectors