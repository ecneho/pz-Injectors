local old_createChildren = ISAdminPanelUI.createChildren

function ISAdminPanelUI:createChildren()
    old_createChildren(self)

    local btnWid = 200
    local btnHgt = getTextManager():getFontHeight(UIFont.Small) + 6

    self.injectorsBtn = ISButton:new(10, 10, btnWid, btnHgt, getText("UI_Injectors_Admin_BtnTools"), self, function()
        if InjectorsAdminWindow.instance then
            InjectorsAdminWindow.instance:removeFromUIManager()
        end

        local ui = InjectorsAdminWindow:new(100, 100, 320, 420)
        ui:initialise()
        ui:addToUIManager()
        InjectorsAdminWindow.instance = ui
    end)

    self.injectorsBtn:initialise()
    self.injectorsBtn:instantiate()
    self.injectorsBtn.borderColor = self.buttonBorderColor

    self:addChild(self.injectorsBtn)
end