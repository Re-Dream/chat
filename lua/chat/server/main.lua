
util.AddNetworkString("chat")

net.Receive("chat", function(_, ply)
	local str = net.ReadString()
	local options = net.ReadTable()

	local msg = gamemode.Call("PlayerSay", ply, str, options.teamChat)
	if not msg or msg == "" then
		return
	else
		str = msg
	end

	local targets = player.GetAll()
	for _, target in next, player.GetAll() do
		local see = gamemode.Call("PlayerCanSeePlayersChat", str, options.teamChat, target, ply)
		if not see then
			table.RemoveByValue(targets, target)
		end
	end

	net.Start("chat")
		net.WriteEntity(ply)
		net.WriteString(str)
		net.WriteTable(options)
	net.Send(targets)
end)