
if IsValid(Chat) then Chat:Remove() end

-- put vanilla stuff in chat.old table
if not chat.vanilla then
	chat = {
		vanilla = chat
	}
end

include("chat/client/util.lua")

-- load vgui components
chat.vgui = {}
for _, fn in next, (file.Find("chat/client/vgui/*.lua", "LUA")) do
	local pnl = include("chat/client/vgui/" .. fn)
	chat.vgui[pnl.Name] = pnl
end
for _, fn in next, (file.Find("lua/chat/client/vgui/*.lua", "GAME")) do -- eh
	local pnl = include("chat/client/vgui/" .. fn)
	chat.vgui[pnl.Name] = pnl
end
for name, pnl in next, chat.vgui do
	vgui.Register(name, pnl, pnl.Base)
end

-- begin main interface
local PANEL = {}

local topSize = 24
function PANEL:Init()
	local w, h = chat.vanilla.GetChatBoxSize()
	h = h + 48
	local x, y = chat.vanilla.GetChatBoxPos()
	y = y - 48

	self:SetPos(x, y)
	self:SetSize(w, h)
	self:DockPadding(9, 9, 9, 9)
	self:SetSizable(true)
	self:SetDeleteOnClose(false)
	function self.btnClose.Paint(s, w, h)
		local col1 = Color(42, 46, 48)
		local col2 = Color(207, 61, 38)

		chat.DrawRoundedBox(4, 0, 0, w, h, col1)

		surface.SetFont(chat.Font(h * 1.175))
		local txt = "❌"
		local txtW, txtH = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.5 - txtW * 0.5 + 1, h * 0.5 - txtH * 0.5 - 3)
		surface.SetTextColor(col2)
		surface.DrawText(txt)
	end

	self.Tabs = vgui.Create("EditablePanel", self)
	self.Tabs:Dock(TOP)
	self.Tabs:SetTall(topSize)
	self.Tabs:DockMargin(0, 0, topSize + 6, 6)
	function self.Tabs.Think(s)
		if s:IsHovered() then
			s:SetCursor("sizeall")
		end
	end
	function self.Tabs.OnMousePressed(s, ...)
		if s:IsHovered() then
			self:OnMousePressed(...)
		end
	end

		local globalTab = vgui.Create("ChatTab", self.Tabs)
		globalTab:Dock(LEFT)
		globalTab:DockMargin(0, 0, 3, 0)
		globalTab:SetText("Global Chat")
		globalTab:SetIcon("chat/global_32.png")
		self.Tabs.Global = globalTab

		local dmsTab = vgui.Create("ChatTab", self.Tabs)
		dmsTab:Dock(LEFT)
		dmsTab:DockMargin(0, 0, 3, 0)
		dmsTab:SetText("Private Chat")
		dmsTab:SetIcon("chat/dms_32.png")
		self.Tabs.DMs = dmsTab

		local settingsTab = vgui.Create("ChatTab", self.Tabs)
		settingsTab:Dock(RIGHT)
		settingsTab:DockMargin(3, 0, 0, 0)
		settingsTab:SetText("Settings")
		settingsTab:SetIcon("chat/settings_32.png")
		self.Tabs.Settings = settingsTab

	self.Content = vgui.Create("EditablePanel", self)
	self.Content:Dock(FILL)
	function self.Content.Paint(s, w, h)
		surface.SetDrawColor(255, 0, 0)
		-- surface.DrawOutlinedRect(0, 0, w, h)
	end

	globalTab.Content = vgui.Create("ChatContentGlobal", self.Content)
	dmsTab.Content = vgui.Create("ChatContent", self.Content)
	settingsTab.Content = vgui.Create("ChatContent", self.Content)

	hook.Add("PreRender", self, function(self)
		if IsValid(self) and self:IsVisible() and input.IsKeyDown(KEY_ESCAPE) then
			if gui.IsGameUIVisible() then
				gui.HideGameUI()
			end

			self:Hide()
		end
	end)

	hook.Add("HUDShouldDraw", self, function(_, name)
		if name == "CHudChat" then
			return false
		end
	end)

	hook.Add("PlayerBindPress", self, function(self, ply, bind, pressed)
		local teamChat = false
		if bind:lower():match("messagemode") then
			chat.Open()
			return true
		elseif bind:lower():match("messagemode2") then
			chat.Open(true)
			return true
		end
	end)

	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:MakePopup()
	globalTab:SetActive()
end

function PANEL:OnMousePressed() -- what a bother
	self.BaseClass.OnMousePressed(self)

	if self:GetDraggable() and gui.MouseY() < (self.y + 48) then -- extend titlebar height, hardcoded values yay
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture(true)
		return
	end
end

function PANEL:PerformLayout(w, h)
	self.BaseClass.PerformLayout(self, w, h)

	self.btnClose:SetSize(topSize, topSize)
	self.btnClose:SetPos(w - 9 - topSize, 9)

	self.btnMinim:SetVisible(false)
	self.btnMaxim:SetVisible(false)
	self.lblTitle:SetVisible(false)
end

function PANEL:Paint(w, h)
	chat.DrawRoundedBox(6, 0, 0, w, h, Color(42, 46, 48, 200))
	chat.DrawRoundedBox(6, 3, 3, w - 6, h - 6, Color(93, 97, 99, 200))
end

function PANEL:Show(teamChat)
	if self:IsVisible() then return end

	self.Tabs.Global:SetActive()
	self:SetMouseInputEnabled(true)
	self:SetVisible(true)

	gamemode.Call("StartChat", teamChat)
end

function PANEL:Hide()
	if not self:IsVisible() then return end

	self:SetMouseInputEnabled(false)
	self:SetVisible(false)

	gamemode.Call("FinishChat")
end
PANEL.Close = PANEL.Hide

vgui.Register("ChatMain", PANEL, "DFrame")

-- populate chat table
function chat.Open(teamChat)
	chat.Create():Show(teamChat)
end
function chat.Close()
	chat.Create():Hide()
end
function chat.AddText(...)
	if IsValid(Chat) then
		Chat.Tabs.Global.Content.TextHistory:AddLine(...)
	else
		chat.vanilla.AddText(...)
	end
end
function chat.GetChatBoxPos()
	if IsValid(Chat) then
		return Chat:GetPos()
	else
		return chat.vanilla.GetChatBoxPos()
	end
end
function chat.GetChatBoxSize()
	if IsValid(Chat) then
		return Chat:GetSize()
	else
		return chat.vanilla.GetChatBoxSize()
	end
end
function chat.Create()
	if not IsValid(Chat) then
		Chat = vgui.Create("ChatMain")
		Chat:SetVisible(false)
	end
	return Chat
end
function chat.Send(str, options)
	net.Start("chat")
		net.WriteString(str)
		net.WriteTable(options or {})
	net.SendToServer()
end

net.Receive("chat", function()
	local ply = net.ReadEntity()
	local str = net.ReadString()
	local options = net.ReadTable()

	local suppr = gamemode.Call("OnPlayerChat", ply, str, options.teamChat, ply:Alive())
	if suppr then return end
end)

-- just in case we haven't implemented everything yet, fallback to vanilla
for k, v in next, chat.vanilla do
	if not chat[k] then
		chat[k] = v
	end
end

chat.Create()

