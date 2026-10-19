local Registry = {}

Registry.Ids = {
    "injector_brown_lightbrown",
    "injector_red_lightblue",
    "injector_black_yellow",
    "injector_red_green",
    "injector_olive_lightblue",
    "injector_bright_green",
    "injector_dark_bluegrey",
    "injector_deep_blue",
    "injector_olive_pink",
    "injector_navy_blue",
    "injector_black_cyan",
    "injector_black_cyan_red",
    "injector_teal_green",
    "injector_grey_bloodred",
    "injector_grey_brown",
    "injector_teal_black",
    "injector_purple_red",
    "injector_yellow_silver",
    "injector_maroon_silver",
    "injector_charcoal_orange",
    "injector_slate_purple",
    "injector_deep_purple"
}

function Registry.GetFullType(id)
    return "Injectors." .. id
end

function Registry.GetSpawnWeight(id)
    local color = string.upper((string.gsub(id, "^injector_", "")))
    local weight = SandboxVars.Injectors and SandboxVars.Injectors["GLOBAL_" .. color .. "_INJECTOR_SPAWN_WEIGHT"]

    return tonumber(weight) or 0
end

return Registry