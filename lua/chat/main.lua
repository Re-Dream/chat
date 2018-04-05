
if IsValid(Chat) then Chat:Remove() end

-- put vanilla stuff in chat.old table
if not chat.vanilla then
	chat = {
		vanilla = chat
	}
end

include("chat/util.lua")

-- load vgui components
chat.vgui = {}
for _, fn in next, (file.Find("lua/chat/vgui/*.lua", "GAME")) do
	local pnl = include("chat/vgui/" .. fn)
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
	self:SetDraggable(true) -- we'll just do our own logic I think
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
	self.Tabs:DockMargin(0, 0, topSize + 6, 0)
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

	self.Tabs.Global = vgui.Create("ChatTab", self.Tabs)
	self.Tabs.Global:Dock(LEFT)
	self.Tabs.Global:DockMargin(0, 0, 3, 0)
	self.Tabs.Global:SetText("Global Chat")
	self.Tabs.Global:SetIcon("chat/global_32.png")

	self.Tabs.DMs = vgui.Create("ChatTab", self.Tabs)
	self.Tabs.DMs:Dock(LEFT)
	self.Tabs.DMs:DockMargin(0, 0, 3, 0)
	self.Tabs.DMs:SetText("Private Chat")
	self.Tabs.DMs:SetIcon("chat/dms_32.png")

	self.Tabs.Settings = vgui.Create("ChatTab", self.Tabs)
	self.Tabs.Settings:Dock(RIGHT)
	self.Tabs.Settings:DockMargin(3, 0, 0, 0)
	self.Tabs.Settings:SetText("Settings")
	self.Tabs.Settings:SetIcon("chat/settings_32.png")
end

function PANEL:OnMousePressed() -- what a bother
	DFrame.OnMousePressed(self)

	if self:GetDraggable() and gui.MouseY() < (self.y + 48) then -- extend titlebar height, hardcoded values yay
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture(true)
		return
	end
end

function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self, w, h)

	self.btnClose:SetSize(topSize, topSize)
	self.btnClose:SetPos(w - 9 - topSize, 9)

	self.btnMinim:SetVisible(false)
	self.btnMaxim:SetVisible(false)
	self.lblTitle:SetVisible(false)
end

function PANEL:Paint(w, h)
	chat.DrawRoundedBox(6, 0, 0, w, h, Color(42, 46, 48))
	chat.DrawRoundedBox(6, 3, 3, w - 6, h - 6, Color(93, 97, 99))
end

vgui.Register("ChatMain", PANEL, "DFrame")

-- populate chat table
function chat.Open()
	if not Chat then
		Chat = vgui.Create("ChatMain")
	end
	Chat:Show()
end
function chat.Close()
	if not Chat then
		Chat = vgui.Create("ChatMain")
	end
	Chat:Hide()
end
function chat.AddText(...)
	-- TO BE IMPLEMENTED
end
function chat.GetChatBoxPos()
	if Chat then
		return Chat:GetPos()
	else
		return chat.vanilla.GetChatBoxPos()
	end
end
function chat.GetChatBoxSize()
	if Chat then
		return Chat:GetSize()
	else
		return chat.vanilla.GetChatBoxSize()
	end
end

Chat = vgui.Create("ChatMain")

-- just in case we haven't implemented everything yet, fallback to vanilla
for k, v in next, chat.vanilla do
	if not chat[k] then
		chat[k] = v
	end
end

