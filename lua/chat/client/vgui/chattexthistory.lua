
local PANEL = {}
PANEL.Name = "ChatTextHistory"
PANEL.Base = "EditablePanel"

function PANEL:Init()
	self.Lines = {}

	hook.Add("HUDPaint", self, function()
		if not self.HUD then return end

		self:PaintManual()
	end)
end

function PANEL:AddLine(...)
	self.Lines[#self.Lines + 1] = { elements = { ... } }
end

function PANEL:SetHUDDrawing(b)
	self:SetMouseInputEnabled(b)
	self:SetPaintedManually(b)
	self:NoClipping(b)
	self.HUD = b
end

local font = chat.Font(20)
function PANEL:Paint(w, h)
	-- print("---------------------------------------------------")
	local usingCol = false
	local x, y = 0, 0
	for i, line in next, self.Lines do
		local blockH, lineH = 0, 0
		for k, obj in next, line.elements do
			if not usingCol then
				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetTextColor(Color(255, 255, 255))
			else
				usingCol = false
			end

			local txt
			local txtW, txtH = 0, 0
			if type(obj):lower() == "table" and obj.r and obj.g and obj.b then
				surface.SetDrawColor(obj)
				surface.SetTextColor(obj)
				usingCol = true
			elseif type(obj):lower() == "player" then
				surface.SetTextColor(team.GetColor(obj:Team()))
				txt = obj:Nick()
			else
				txt = tostring(obj)
			end

			if txt and txt:Trim() ~= "" then
				local split = txt:Split(" ")
				for k, word in next, split do
					if word:Trim() ~= "" then
						surface.SetFont(font)
						local txt = word .. (k == #split and "" or " ")
						local wordW, wordH = surface.GetTextSize(txt)

						if lineH < wordH then
							lineH = wordH
						end

						if x + wordW > w then
							y = y + lineH
							blockH = blockH + lineH
							lineH = 0
							x = 0
						end

						surface.SetTextPos(x, y)
						surface.DrawText(txt)
						x = x + wordW
					end
				end
			end
		end
		y = y + lineH
		x = 0
	end
end

return PANEL

