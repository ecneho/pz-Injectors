require "ISUI/ISPanel"

InjectorsAdminWindow = ISPanel:derive("InjectorsAdminWindow")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

function InjectorsAdminWindow:initialise()
    ISPanel.initialise(self)
end

function InjectorsAdminWindow:createChildren()

    local x, y = UI_BORDER_SPACING + 1, FONT_HGT_MEDIUM + UI_BORDER_SPACING * 2 + 1
    local btnWid = 220

    self.buttons = {}

    -- Command buttons
    local commands = {
        { text = "Dump Sandbox Variables", command = "DumpVariables" },
        { text = "Reduce General Health", command = "ReduceGeneralHealth" },
        { text = "Apply Bleeding and Deep Wounds", command = "ApplyBleedingDeepWounds" },
        { text = "Set Maximum Applicable Pain", command = "SetMaximumPain" },
        { text = "Reload Sandbox Variables", command = "ReloadVariables" },
    }

    for _, c in ipairs(commands) do
        local b = ISButton:new(x, y, btnWid, BUTTON_HGT, c.text, self, InjectorsAdminWindow.onCommand)
        b.internal = c.command
        b.borderColor = self.buttonBorderColor
        b:initialise()
        b:instantiate()
        self:addChild(b)
        table.insert(self.buttons, b)
    end

    -- InjectorConstructorUI button
    local openConstructor = ISButton:new(x, y, btnWid, BUTTON_HGT, "Open Injector Constructor", self,
        function()
            if InjectorConstructorUI then
                if InjectorConstructorUI.instance then
                    InjectorConstructorUI.instance:removeFromUIManager()
                end
                local ui = InjectorConstructorUI:new(100, 100, 600, 450)
                ui:initialise()
                ui:addToUIManager()
                InjectorConstructorUI.instance = ui
            end
        end
    )
    openConstructor:initialise()
    openConstructor:instantiate()
    openConstructor.borderColor = self.buttonBorderColor
    self:addChild(openConstructor)
    table.insert(self.buttons, openConstructor)

    -- InjectorEffectPanelUI button
    local openEffects = ISButton:new(x, y, btnWid, BUTTON_HGT, "Open Injector Effects Panel", self,
        function()
            if InjectorEffectPanelUI then
                if InjectorEffectPanelUI.instance then
                    InjectorEffectPanelUI.instance:removeFromUIManager()
                end
                local ui = InjectorEffectPanelUI:new(100, 100, 350, 400)
                ui:initialise()
                ui:addToUIManager()
                InjectorEffectPanelUI.instance = ui
            end
        end
    )
    openEffects:initialise()
    openEffects:instantiate()
    openEffects.borderColor = self.buttonBorderColor
    self:addChild(openEffects)
    table.insert(self.buttons, openEffects)

    -- Close button
    local close = ISButton:new(x, y, btnWid, BUTTON_HGT, "CLOSE", self, InjectorsAdminWindow.onClose)
    close:initialise()
    close:instantiate()
    close.borderColor = self.buttonBorderColor
    self:addChild(close)
    table.insert(self.buttons, close)

    -- render
    local bottom = 0
    for i, b in ipairs(self.buttons) do
        b:setX(x)
        b:setY(y + (i - 1) * (BUTTON_HGT + UI_BORDER_SPACING))
        bottom = b:getBottom()
    end

    self:setWidth(btnWid + x * 2)
    self:setHeight(bottom + UI_BORDER_SPACING)
end

function InjectorsAdminWindow:render()
    local title = "INJECTORS PANEL"
    self:drawText(title,
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, title) / 2),
        UI_BORDER_SPACING,
        1,1,1,1,
        UIFont.Medium
    )
end

function InjectorsAdminWindow:onCommand(btn)
    sendClientCommand("InjectorsModule", btn.internal, {})
end

function InjectorsAdminWindow:onClose()
    self:removeFromUIManager()
    InjectorsAdminWindow.instance = nil
end

function InjectorsAdminWindow:new(x,y,w,h)
    local o = ISPanel:new(x,y,w,h)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r=0,g=0,b=0,a=0.85}
    o.borderColor = {r=0.4,g=0.4,b=0.4,a=1}
    o.buttonBorderColor = {r=0.7,g=0.7,b=0.7,a=0.5}
    o.moveWithMouse = true
    return o
end