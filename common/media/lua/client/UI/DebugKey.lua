function Debug_PrintData(player)
    local bodyDamage = player:getBodyDamage()
    local parts = bodyDamage:getBodyParts()

    print("========================")

    for i = 0, parts:size() - 1 do
        local part = parts:get(i)

        print(
            "Part: " .. tostring(part:getType())
        )
    end

    print("========================")

    print(Propital.MEND_BLEEDING_BASEDELTA)
    print(Propital.COEFFICIENTS[BodyPartType.ForeArm_L])

    print("========================")
end

Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_G then
        local player = getPlayer()
        if player then
            Debug_PrintData(player)
        end
    end
end)