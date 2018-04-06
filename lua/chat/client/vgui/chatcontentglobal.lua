
local PANEL = {}
PANEL.Name = "ChatContentGlobal"
PANEL.Base = "ChatContent"

function PANEL:Init()
	self.BaseClass.Init(self)

	self.TextHistory = vgui.Create("ChatTextHistory", self)
	self.TextHistory:Dock(FILL)
	self.TextHistory:DockMargin(0, 0, 0, 6)

	self.ChatBar = vgui.Create("EditablePanel", self)
	self.ChatBar:Dock(BOTTOM)
	self.ChatBar:SetTall(24)
	function self.ChatBar.Paint(s, w, h)
		chat.DrawRoundedBox(h * 0.5, 0, 0, w, h, Color(194, 196, 196))
	end
	function self.ChatBar.PerformLayout(s, w, h)
		self.TextEntry:DockMargin(h * 0.5 - 5, 0, 0, 0)
	end

	self.TextEntry = vgui.Create("DTextEntry", self.ChatBar)
	self.TextEntry:Dock(FILL)
	self.TextEntry:SetPlaceholderText("Enter a Message:")
	self.TextEntry:SetFont(chat.Font(18))
	function self.TextEntry.Paint(s, w, h)
		if s:GetPlaceholderText() and s:GetPlaceholderText():Trim() ~= "" and (not s:GetText() or s:GetText() == "") then
			local oldText = s:GetText()

			local str = s:GetPlaceholderText()
			if str:StartWith("#") then str = str:sub(2) end
			str = language.GetPhrase(str)

			s:SetText(str)
			s:DrawTextEntryText(Color(142, 144, 146), Color(88, 201, 243), Color(93, 97, 99))
			s:SetText(oldText)

			return
		end

		s:DrawTextEntryText(Color(42, 46, 48), Color(88, 201, 243), Color(93, 97, 99))
	end
	function self.TextEntry.OnKeyCodeTyped(s, code)
		if code == KEY_ENTER then
			chat.Send(s:GetText())
			s:SetText("")
			chat.Close()
		end

		if code == KEY_UP then
			-- to be implemented
		end

		if code == KEY_DOWN or code == KEY_TAB then
			-- to be implemented
		end
	end
end

function PANEL:Show()
	self.BaseClass.Show(self)

	self.TextEntry:RequestFocus()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 255)
	-- surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
end

return PANEL

