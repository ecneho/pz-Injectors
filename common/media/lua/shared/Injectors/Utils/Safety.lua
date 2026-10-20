local Safety = {}

---@param level number
function Safety.IsBlocked(level)
    local vars = SandboxVars.Injectors

    if not vars then return false end
    if vars.GLOBAL_OVERDOSE_DEATH_ENABLED then return false end
    if not vars.GLOBAL_OVERDOSE_BLOCK_ENABLED then return false end

    return level >= (tonumber(vars.GLOBAL_OVERDOSE_THRESHOLD) or 100)
end

return Safety