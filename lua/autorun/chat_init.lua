
if SERVER then
	AddCSLuaFile("chat/main.lua")
end

if CLIENT then
	include("chat/main.lua")
end

