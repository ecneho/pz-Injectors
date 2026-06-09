---@param iso IsoPlayer
function IncrementOverdose(iso)
    local modData = iso:getModData()
    modData.overdose = modData.overdose or 0
    modData.overdose = modData.overdose + Epinephrine.OVERDOSE_PENALTY
end