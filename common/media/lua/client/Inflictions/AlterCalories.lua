--- B42.17 revision
--- @param iso IsoPlayer
function AlterCalories(iso, deviation)
    local nutrition = iso:getNutrition()
    local calories = nutrition:getCalories()
    local value = Clamp(calories + deviation, -2200, 3700)
    nutrition:setCalories(value)
end