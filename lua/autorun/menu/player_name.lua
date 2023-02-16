local new_module = {}

new_module.name = "Player name shower"
new_module.id = "player_name"
new_module.version = "1.0"

include("../libs/better_string.lua")

function new_module:init()
    surface.CreateFont("player_name_name", {font = "FontAwesome",size = 22,antialias = true,shadow = true})
    surface.CreateFont("player_name_rank", {font = "FontAwesome",size = 15,antialias = true,shadow = true})
end

function new_module:hud()
    for _, ply in pairs(player.GetAll()) do
        local ts = (ply:EyePos() + Vector(0,0,20)):ToScreen()
        if not ts.visible then return end

        draw.SimpleText("" .. ply:GetName(), "player_name_name", ts.x, ts.y - 15, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(format_higher(language.GetPhrase("rank")) .. ": " .. team.GetName(ply:Team()), "player_name_rank", ts.x, ts.y, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function new_module:update()
end

return {module=new_module}