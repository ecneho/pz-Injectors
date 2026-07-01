require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISLabel"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10

InjectorEffectPanelUI = ISCollapsableWindow:derive("InjectorEffectPanelUI")

function InjectorEffectPanelUI:initialise()
    ISCollapsableWindow.initialise(self)
    self.title = "Injector Effects"
end

function InjectorEffectPanelUI:createChildren()
    ISCollapsableWindow.createChildren(self)

    local barSectionHeight = 40
    local yOff = self:titleBarHeight() + barSectionHeight + UI_BORDER_SPACING

    self.effectList = ISScrollingListBox:new(UI_BORDER_SPACING, yOff, self.width - (UI_BORDER_SPACING * 2), self.height - yOff - UI_BORDER_SPACING)
    self.effectList:initialise()
    self.effectList:instantiate()

    self.effectList.itemheight = FONT_HGT_MEDIUM + FONT_HGT_SMALL + 12
    self.effectList.selected = 0
    self.effectList.doDrawItem = self.drawEffectListItem
    self.effectList.drawBorder = true
    self.effectList.borderColor = self.borderColor

    self:addChild(self.effectList)
end

function InjectorEffectPanelUI:loadData()
    local data = InjectorData

    self.overdoseLevel = data.overdoseLevel or 0
    self.maxOverdose = data.maxOverdose or 100

    self.effectList:clear()

    for _, effect in ipairs(data.effects) do
        self.effectList:addItem(effect.effectId, effect)
    end
end

function InjectorEffectPanelUI:render()
    ISCollapsableWindow.render(self)

    local barY = self:titleBarHeight() + UI_BORDER_SPACING
    local barX = UI_BORDER_SPACING
    local barWidth = self.width - (UI_BORDER_SPACING * 2)
    local barHeight = 24

    local fillRatio = 0
    if self.maxOverdose and self.maxOverdose > 0 then
        fillRatio = math.min(self.overdoseLevel / self.maxOverdose, 1.0)
    end

    local r, g, b = 0.2, 0.8, 0.2
    if fillRatio > 0.8 then
        r, g, b = 0.8, 0.2, 0.2
    elseif fillRatio > 0.5 then
        r, g, b = 0.8, 0.8, 0.2
    end

    self:drawRect(barX, barY, barWidth, barHeight, 1, 0.1, 0.1, 0.1)
    self:drawRect(barX, barY, barWidth * fillRatio, barHeight, 1, r, g, b)
    self:drawRectBorder(barX, barY, barWidth, barHeight, 1, 0.5, 0.5, 0.5)

    local text = "Overdose Level: " .. tostring(math.floor(self.overdoseLevel)) .. " / " .. tostring(self.maxOverdose)
    self:drawTextCentre(text, barX + (barWidth / 2), barY + (barHeight / 2) - (FONT_HGT_SMALL / 2), 1, 1, 1, 1, UIFont.Small)
end

function InjectorEffectPanelUI:drawEffectListItem(y, item, alt)
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.3, 0.7, 0.35, 0.15)
    elseif alt then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.3, 0.6, 0.5, 0.5)
    end
    self:drawRectBorder(0, y, self:getWidth(), self.itemheight, 0.9, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    local eff = item.item
    local innerY = y + 4
    local contentWidth = self:getWidth() - (UI_BORDER_SPACING * 2)

    local titleText = eff.effectId
    self:drawText(titleText, UI_BORDER_SPACING, innerY, 1, 1, 1, 0.9, UIFont.Medium)

    local barR, barG, barB = 0.2, 0.7, 0.2 
    local statusText = ""
    local fillRatio = 0

    if eff.delayLeft > 0 then
        local delayRemaining = eff.delayLeft

        fillRatio = delayRemaining / math.max(1, eff.delay)
        barR, barG, barB = 0.8, 0.5, 0.1
        statusText = string.format("Delayed: %d/%d", delayRemaining, eff.delay)
    else
        local activeRemaining = eff.ticksLeft

        fillRatio = activeRemaining / math.max(1, eff.duration)
        statusText = string.format("Active: %d/%d", activeRemaining, eff.duration)
    end

    fillRatio = math.max(0, math.min(fillRatio, 1.0))

    local statusWidth = getTextManager():MeasureStringX(UIFont.Small, statusText)
    self:drawText(statusText, self:getWidth() - statusWidth - UI_BORDER_SPACING, innerY + (FONT_HGT_MEDIUM - FONT_HGT_SMALL) / 2, 0.7, 0.7, 0.7, 0.9, UIFont.Small)

    innerY = innerY + FONT_HGT_MEDIUM + 4
    local effectBarHeight = 10
    self:drawRect(UI_BORDER_SPACING, innerY, contentWidth, effectBarHeight, 1, 0.05, 0.05, 0.05)
    self:drawRect(UI_BORDER_SPACING, innerY, contentWidth * fillRatio, effectBarHeight, 1, barR, barG, barB)
    self:drawRectBorder(UI_BORDER_SPACING, innerY, contentWidth, effectBarHeight, 1, 0.3, 0.3, 0.3)

    return y + self.itemheight
end

function InjectorEffectPanelUI:update()
    ISCollapsableWindow.update(self)
    self:loadData()
end

function InjectorEffectPanelUI:new(x, y, width, height)
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2)
        y = (getCore():getScreenHeight() / 2) - (height / 2)
    end

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.resizable = false
    o.moveWithMouse = true

    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}

    return o
end

function OpenInjectorCharacterInfo()
    local ui = InjectorEffectPanelUI:new(0, 0, 350, 400)
    ui:initialise()
    ui:addToUIManager()
end

Events.OnGameStart.Add(OpenInjectorCharacterInfo)