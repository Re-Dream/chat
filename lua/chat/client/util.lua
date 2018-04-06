
chat.fonts = {}
function chat.Font(size)
	local name = "customchat_" .. size
	if not chat.fonts[name] then
		surface.CreateFont(name, {
			font = "Segoe UI",
			size = size,
			weight = 500,
			shadow = false
		})
		chat.fonts[name] = true
	end
	return name
end

local corner = Material("chat/corner.png", "smooth mips")
function chat.DrawRoundedBox(borderSize, x, y, w, h, col)
	surface.SetDrawColor(col.r, col.g, col.b, col.a)

	x = math.Round(x)
	y = math.Round(y)
	w = math.Round(w)
	h = math.Round(h)
	borderSize = math.min(math.Round(borderSize), math.floor(w * 0.5))

	-- Draw as much of the rect as we can without textures
	surface.DrawRect(x + borderSize, y, w - borderSize * 2, h)
	surface.DrawRect(x, y + borderSize, borderSize, h - borderSize * 2)
	surface.DrawRect(x + w - borderSize, y + borderSize, borderSize, h - borderSize * 2)

	surface.SetMaterial(corner)

	surface.DrawTexturedRectUV(x, y, borderSize, borderSize, 0, 0, 1, 1)
	surface.DrawTexturedRectUV(x + w - borderSize, y, borderSize, borderSize, 1, 0, 0, 1)
	surface.DrawTexturedRectUV(x, y + h -borderSize, borderSize, borderSize, 0, 1, 1, 0)
	surface.DrawTexturedRectUV(x + w - borderSize, y + h - borderSize, borderSize, borderSize, 1, 1, 0, 0)
end