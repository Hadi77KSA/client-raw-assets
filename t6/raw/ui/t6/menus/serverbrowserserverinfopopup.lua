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
		self.buttonList:addText("No server selected") -- todo localize
	else
		self.connectButton = self.buttonList:addDvarLeftRightSelector( owner, "CONNECT TO SERVER", "", "Connect to the server." ) -- todo localize
		self.connectButton:registerEventHandler( "button_action", CoD.ServerBrowserServerInfo.Connect )

		self.buttonList:addText("HOSTNAME: " .. CoD.ServerList.SelectedServer.hostname) -- todo localize
		self.buttonList:addText("MAX PLAYERS: " .. CoD.ServerList.SelectedServer.maxplayers) -- todo localize
		self.buttonList:addText("MAP NAME: " .. CoD.ServerList.SelectedServer.displayable_map) -- todo localize
		self.buttonList:addText("GAMETYPE: " .. CoD.ServerList.SelectedServer.displayable_gametype) -- todo localize
		self.buttonList:addText("PING: " .. CoD.ServerList.SelectedServer.ping) -- todo localize
		self.buttonList:addText("PLAYERS: " .. #CoD.ServerList.SelectedServer.players) -- todo localize
	end

	if not self.buttonList:restoreState() then
		self.buttonList:processEvent( {
			name = "gain_focus"
		} )
	end

	self:registerEventHandler( "button_prompt_back", CoD.ServerBrowserServerInfo.Back )
	return self
end

