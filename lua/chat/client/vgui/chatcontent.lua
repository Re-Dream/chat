
local PANEL = {}
PANEL.Name = "ChatContent"
PANEL.Base = "EditablePanel"

function PANEL:Init()
	self:Dock(FILL)
	self:SetVisible(false)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 255, 0)
	-- surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
end

function PANEL:Show()
	if self:IsVisible() then return end

	self:SetVisible(true)
	self:AlphaTo(255, 0.25)
end

function PANEL:Hide()
	if not self:IsVisible() then return end

	self:AlphaTo(0, 0.25, 0, function()
		self:SetVisible(false)
	end)
end

return PANEL

