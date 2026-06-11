local original_ISEatFoodAction_new = ISEatFoodAction.new

function ISEatFoodAction:new(character, item, percentage)
    local o = original_ISEatFoodAction_new(self, character, item, percentage)
    if item:getEatType() == "Injector" then
        o.maxTime = 10 -- TODO: add a variable
    end
    return o
end