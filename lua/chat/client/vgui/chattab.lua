
local PANEL = {}
PANEL.Name = "ChatTab"
PANEL.Base = "Button"

function PANEL:Init()
	self:SetWide(28)
end

function PANEL:SetIcon(path, ...)
	if type(path) == "IMaterial" then
		self.Icon = path
	else
		self.Icon = Material(path, "smooth mips")
	end
end

function PANEL:SetActive()
	if not self.Content then return end
	if self.Active then return end

	-- set other tab buttons as inactive
	for _, pnl in next, self:GetParent():GetChildren() do
		if pnl ~= self and (pnl.ClassName == "ChatTab" or pnl.Base == "ChatTab") then
			pnl.Active = false
		end
	end
	self.Active = true

	-- hide content that isn't ours
	for _, pnl in next, self.Content:GetParent():GetChildren() do
		if pnl ~= self.Content and (pnl.ClassName == "ChatContent" or pnl.Base == "ChatContent") then
			pnl:Hide()
		end
	end
	self.Content:Show()

	-- Chat.Content.Active
	self.Content:GetParent().Active = self
end

function PANEL:DoClick()
	surface.PlaySound("garrysmod/ui_click.wav")
	self:SetActive()
end

function PANEL:Paint(w, h)
	chat.DrawRoundedBox(h * 0.5, 0, 0, w, h, self.Active and Color(88, 201, 243) or Color(194, 196, 196))

	surface.SetMaterial(self.Icon or "debug/debugwhite")
	surface.DrawTexturedRect(2, 2, h - 4, h - 4)

	surface.SetFont(chat.Font(16))
	local txt = self:GetText()
	local txtW, txtH = surface.GetTextSize(txt)
	surface.SetTextPos(h, h * 0.5 - txtH * 0.5)
	surface.SetTextColor(Color(42, 46, 48))
	surface.DrawText(txt)

	self.Width = Lerp(FrameTime() * 7.5, self.Width or self:GetWide(), self:IsHovered() and h + 4 + txtW + 4 or h)
	self:SetWide(math.floor(self.Width))

	return true
end

return PANEL

