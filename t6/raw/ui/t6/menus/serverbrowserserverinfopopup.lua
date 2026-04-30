CoD.ServerBrowserServerInfo = {}

CoD.ServerBrowserServerInfo.Back = function (self, event)
	self:saveState()
	self:goBack(event.controller)
end

CoD.ServerBrowserServerInfo.Connect = function (self, event)
	Engine.Exec(event.controller, "stopRefreshServers\n")
	Engine.Exec(event.controller, "connect \"" .. CoD.ServerList.SelectedServer.ip .. ":" .. CoD.ServerList.SelectedServer.port .. "\"\n")
end

LUI.createMenu.ServerBrowserServerInfo = function ( owner )
	local self = CoD.GameOptionsMenu.New( owner, "ServerBrowserServerInfo" )

	if CoD.isZombie == true then
		self.infoPane:removeElement(self.gametypeIcon)
	end

	self:addTitle( Engine.Localize( "MENU_SERVER_INFORMATION" ) )

	if CoD.ServerList.SelectedServer == nil then
		self.buttonList:addText( Engine.Localize("SERVERBROWSER_NO_SERVER_SELECTED") )
	else
		self.connectButton = self.buttonList:addDvarLeftRightSelector( owner, Engine.Localize("SERVERBROWSER_CONNECT_TO_SERVER_CAPS"), "", Engine.Localize("SERVERBROWSER_CONNECT_TO_SERVER_HINT") )
		self.connectButton:registerEventHandler( "button_action", CoD.ServerBrowserServerInfo.Connect )

		self.buttonList:addText(Engine.Localize("SERVERBROWSER_HOSTNAME", CoD.ServerList.SelectedServer.hostname))
		self.buttonList:addText(Engine.Localize("SERVERBROWSER_MAX_PLAYERS", CoD.ServerList.SelectedServer.maxplayers))
		self.buttonList:addText(Engine.Localize("SERVERBROWSER_MAP_NAME", CoD.ServerList.SelectedServer.displayable_map))
		self.buttonList:addText(Engine.Localize("SERVERBROWSER_GAMETYPE", CoD.ServerList.SelectedServer.displayable_gametype))
		self.buttonList:addText(Engine.Localize("SERVERBROWSER_PING", CoD.ServerList.SelectedServer.ping))
		self.buttonList:addText(Engine.Localize("SERVERBROWSER_PLAYERS", #CoD.ServerList.SelectedServer.players))
	end

	if not self.buttonList:restoreState() then
		self.buttonList:processEvent( {
			name = "gain_focus"
		} )
	end

	self:registerEventHandler( "button_prompt_back", CoD.ServerBrowserServerInfo.Back )
	return self
end

