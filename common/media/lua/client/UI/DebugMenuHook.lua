require "DebugUIs/ISDebugMenu"

local TAB = "MAIN"
local POSITION = "top"

local function openInjectorsWindow()
    if InjectorsAdminWindow.instance then
        InjectorsAdminWindow.instance:removeFromUIManager()
    end

    local ui = InjectorsAdminWindow:new(100, 100, 320, 420)
    ui:initialise()
    ui:addToUIManager()
    InjectorsAdminWindow.instance = ui
end

local old_setupButtons = ISDebugMenu.setupButtons

function ISDebugMenu:setupButtons()
    old_setupButtons(self)

    local info = {
        title = getText("UI_Injectors_Admin_BtnTools"),
        func = openInjectorsWindow,
        tab = TAB,
        marginTop = 0,
    }

    local closeTitle = getText("IGUI_DebugMenu_Close")
    local firstInTab, closeInTab

    for i, v in ipairs(self.buttons) do
        if v.tab == TAB then
            firstInTab = firstInTab or i
            if v.title == closeTitle and not v.func then
                closeInTab = i
            end
        end
    end

    local index
    if POSITION == "bottom" then
        index = closeInTab or (#self.buttons + 1)
    elseif TAB == "MAIN" then
        index = (firstInTab or 0) + 1 -- keep "General" first
    else
        index = firstInTab or (#self.buttons + 1)
    end

    table.insert(self.buttons, index, info)
end