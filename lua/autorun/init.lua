
if SERVER then
    AddCSLuaFile("cl_loader.lua")
    AddCSLuaFile("sv_net.lua")
end

if CLIENT then
    include("cl_loader.lua")
    include("sv_net.lua")
end