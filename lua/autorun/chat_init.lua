
if SERVER then
	AddCSLuaFile("chat/client/main.lua")
	include("chat/server/main.lua")
end

if CLIENT then
	include("chat/client/main.lua")
end

