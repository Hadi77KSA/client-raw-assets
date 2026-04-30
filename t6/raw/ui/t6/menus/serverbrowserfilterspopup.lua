CoD.ServerBrowserFilters = {}

CoD.ServerBrowserFilters.Back = function (self, event)
	Engine.Exec(event.controller, "updateFilterServers\n")
	self:saveState()
	self:goBack(event.controller)
end

CoD.ServerBrowserFilters.UpdateSearchFilterText = function (self, text)
	if text == nil then
		text = UIExpression.DvarString(0, "ui_serverbrowser_searchfilter")
	end

	self:setText(Engine.Localize("MENU_SERVER_BROWSER_CURRENT", text))
	Engine.ExecNow(0, "set ui_serverbrowser_searchfilter \"" .. text .. "\"\n")
end

CoD.ServerBrowserFilters.OpenFilterEditor = function (self, event)
	Engine.Exec(0, "ui_keyboard_new 7 \"" .. Engine.Localize("MENU_SERVER_BROWSER_FILTER") .. "\"\"" .. UIExpression.DvarString(0, "ui_serverbrowser_searchfilter") .. "\"" .. 256)
end

CoD.ServerBrowserFilters.FilterChanged = function (self, event)
	if event.type ~= 7 then
		return
	end
	
	CoD.ServerBrowserFilters.UpdateSearchFilterText(self.currentText, event.input)
end

CoD.ServerBrowserFilters.ResetToDefaults = function (self, event)
	Engine.ExecNow(0, "set ui_serverbrowser_searchfilter \"\"\n")
	Engine.ExecNow(0, "set ui_serverbrowser_searchfilter_emptyservers 1\n")

	self:processEvent( {
		name = "button_prompt_back"
	} )
end

LUI.createMenu.ServerBrowserFilters = function ( owner )
	local self = CoD.GameOptionsMenu.New( owner, "ServerBrowserFilters" )

	if CoD.isZombie == true then
		self.infoPane:removeElement(self.gametypeIcon)
	end

	self:addTitle( Engine.Localize( "MENU_FILTER_SERVERS_CAPS" ) )

	self.searchFilter = self.buttonList:addDvarLeftRightSelector( owner, Engine.Localize("MENU_SERVER_BROWSER_SEARCH_FILTER_CAPS"), "", Engine.Localize("MENU_SERVER_BROWSER_SEARCH_FILTER_HINT") )
	self.searchFilter.currentText = self.buttonList:addText("")
	self.searchFilter:registerEventHandler( "ui_keyboard_input", CoD.ServerBrowserFilters.FilterChanged )
	self.searchFilter:registerEventHandler( "button_action", CoD.ServerBrowserFilters.OpenFilterEditor )
	CoD.ServerBrowserFilters.UpdateSearchFilterText(self.searchFilter.currentText, nil)

	self.buttonList:addText("") -- seperator
	
	self.difficultyButton = self.buttonList:addDvarLeftRightSelector( owner, Engine.Localize("MENU_SERVER_BROWSER_DISPLAY_EMPTY_CAPS"), "ui_serverbrowser_searchfilter_emptyservers", Engine.Localize("MENU_SERVER_BROWSER_DISPLAY_EMPTY_HINT") )
	CoD.GameOptions.Button_AddChoices( owner, self.difficultyButton, { "MENU_NO", "MENU_YES" }, { 0, 1 } )


	self.defaultsButton = CoD.ButtonPrompt.new("alt1", Engine.Localize("PLATFORM_RESET_TO_DEFAULT"), self, "button_prompt_defaults", false, nil, nil, nil, "R", nil)
	self:addRightButtonPrompt(self.defaultsButton)
	self:registerEventHandler( "button_prompt_defaults", CoD.ServerBrowserFilters.ResetToDefaults )

	if not self.buttonList:restoreState() then
		self.buttonList:processEvent( {
			name = "gain_focus"
		} )
	end

	self:registerEventHandler( "button_prompt_back", CoD.ServerBrowserFilters.Back )
	return self
end

