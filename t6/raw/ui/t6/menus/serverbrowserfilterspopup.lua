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

	self:setText("CURENT: " .. text) -- todo localize
	Engine.ExecNow(0, "set ui_serverbrowser_searchfilter \"" .. text .. "\"\n")
end

CoD.ServerBrowserFilters.OpenFilterEditor = function (self, event)
	Engine.Exec(0, "ui_keyboard_new 7 " .. "\"Enter a filter\"" .. "\"" .. UIExpression.DvarString(0, "ui_serverbrowser_searchfilter") .. "\"" .. 256) -- todo localize
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

	self.searchFilter = self.buttonList:addDvarLeftRightSelector( owner, "SEARCH FILTER", "", "Enter text to filter the server list by." ) -- todo localize
	self.searchFilter.currentText = self.buttonList:addText("")
	self.searchFilter:registerEventHandler( "ui_keyboard_input", CoD.ServerBrowserFilters.FilterChanged )
	self.searchFilter:registerEventHandler( "button_action", CoD.ServerBrowserFilters.OpenFilterEditor )
	CoD.ServerBrowserFilters.UpdateSearchFilterText(self.searchFilter.currentText, nil)

	self.buttonList:addText("") -- seperator
	
	self.difficultyButton = self.buttonList:addDvarLeftRightSelector( owner, "DISPLAY EMPTY SERVERS", "ui_serverbrowser_searchfilter_emptyservers", "Show empty servers on the server list." ) -- todo localize
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

