require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISLabel"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10

InjectorEffectPanelUI = ISCollapsableWindow:derive("InjectorEffectPanelUI")

function InjectorEffectPanelUI:initialise()
    ISCollapsableWindow.initialise(self)
    self.title = "Injector Effects"
end

function InjectorEffectPanelUI:createChildren()
    ISCollapsableWindow.createChildren(self)

    local barHeight = 24
    local barY = self:titleBarHeight() + UI_BORDER_SPACING
    local yOff = barY + barHeight + UI_BORDER_SPACING

    self.effectList = ISScrollingListBox:new(UI_BORDER_SPACING, yOff,
        self.width - (UI_BORDER_SPACING * 2),
        self.height - yOff - UI_BORDER_SPACING)

    self.effectList:initialise()
    self.effectList:instantiate()

    self.effectList.itemheight = FONT_HGT_SMALL + 18
    self.effectList.selected = 0
    self.effectList.doDrawItem = self.drawEffectListItem
    self.effectList.drawBorder = true
    self.effectList.borderColor = self.borderColor

    self:addChild(self.effectList)

    sendClientCommand("InjectorsModule", "RequestEffects", {})
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

    local text = "pending..."

    if self.overdoseLevel and self.maxOverdose and self.maxOverdose > 0 then
        text = "Overdose Level: " .. self.overdoseLevel .. " / " .. self.maxOverdose
    end

    self:drawTextCentre(text, barX + (barWidth / 2), barY + (barHeight / 2) - (FONT_HGT_SMALL / 2), 1, 1, 1, 1, UIFont.Small)
end

function InjectorEffectPanelUI:drawEffectListItem(y, item, alt)
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.3, 0.7, 0.35, 0.15)
    elseif alt then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.15, 1, 1, 1)
    end

    local eff = item.item
    local contentWidth = self:getWidth() - (UI_BORDER_SPACING * 2)

    local statusText = (eff.delayLeft > 0) and string.format("Delay: %ds", eff.delayLeft) or string.format("Time: %d", eff.ticksLeft)
    self:drawText(eff.effectId, UI_BORDER_SPACING, y + 2, 1, 1, 1, 0.9, UIFont.Small)
    self:drawTextRight(statusText, self:getWidth() - UI_BORDER_SPACING, y + 2, 0.7, 0.7, 0.7, 0.9, UIFont.Small)

    local fillRatio = math.max(0, math.min((eff.delayLeft > 0) and (eff.delayLeft / math.max(1, eff.delay)) or (eff.ticksLeft / math.max(1, eff.duration)), 1.0))
    local barR, barG, barB = (eff.delayLeft > 0) and 0.8 or 0.2, (eff.delayLeft > 0) and 0.5 or 0.7, 0.1

    local barY = y + FONT_HGT_SMALL + 6
    self:drawRect(UI_BORDER_SPACING, barY, contentWidth, 6, 0.5, 0.1, 0.1, 0.1)
    self:drawRect(UI_BORDER_SPACING, barY, contentWidth * fillRatio, 6, 0.8, barR, barG, barB)

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