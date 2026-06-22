-- server only
if not isServer() then return end

local Overdose = {}

---@type table|nil
local overdoseList = nil

local function getList()
    if not overdoseList then
        overdoseList = ModData.getOrCreate("Injectors_OverdoseList")
    end

    return overdoseList
end

---@param username string
---@return number
function Overdose.Get(username)
    return getList()[username] or 0
end

---@param username string
---@param amount number
function Overdose.Set(username, amount)
    getList()[username] = amount
end

---@param username string
---@param amount number
function Overdose.Add(username, amount)
    local list = getList()
    list[username] = (list[username] or 0) + amount
end

---@param username string
function Overdose.Clear(username)
    getList()[username] = 0
end

---@param username string
---@return boolean
function Overdose.Has(username)
    return (getList()[username] or 0) > 0
end

---@param username string
---@param amount number
function Overdose.Decay(username, amount)
    local current = Overdose.Get(username)
    local newValue = math.max(0, current - amount)

    if newValue == 0 then
        getList()[username] = nil
    else
        getList()[username] = newValue
    end

    return newValue
end

return Overdose