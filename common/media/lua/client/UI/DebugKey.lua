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

    print(SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_RATE)

    print("========================")
end

Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_G then
        local player = getPlayer()
        if player then
            Debug_PrintData(player)
            InitSandboxVariables()
        end
    end
end)