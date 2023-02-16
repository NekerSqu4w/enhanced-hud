local new_module = {}

new_module.name = "Better Crosshair"
new_module.id = "better_crosshair"
new_module.version = "1.0"

include("../libs/better_render.lua")

function new_module:init()
    new_module.spread = 0
    new_module.spread_smooth = 0

    CreateClientConVar("crosshair_show", 1, true, false)

    CreateClientConVar("crosshair_r", 70, true, false)
    CreateClientConVar("crosshair_g", 255, true, false)
    CreateClientConVar("crosshair_b", 70, true, false)
    
    CreateClientConVar("crosshair_enemy_r", 255, true, false)
    CreateClientConVar("crosshair_enemy_g", 70, true, false)
    CreateClientConVar("crosshair_enemy_b", 70, true, false)

    CreateClientConVar("crosshair_ally_r", 70, true, false)
    CreateClientConVar("crosshair_ally_g", 255, true, false)
    CreateClientConVar("crosshair_ally_b", 255, true, false)

    CreateClientConVar("crosshair_thickness", 1, true, false)
    CreateClientConVar("crosshair_bar_height", 8, true, false)
    CreateClientConVar("crosshair_bar_size", 4, true, false)
    CreateClientConVar("crosshair_reset", "false", true, false)

    timer.Create("better_crosshair_loop",0.01,0,function()
        new_module.spread_smooth = Lerp(0.15,new_module.spread_smooth,new_module.spread)
    end)
end

function new_module:hud()
    local eye_trace = LocalPlayer():GetEyeTrace()

    if not LocalPlayer():InVehicle() and GetConVarNumber("crosshair_show") == 1 then
        new_module.crosshair_color = Color(GetConVarNumber("crosshair_r"),GetConVarNumber("crosshair_g"),GetConVarNumber("crosshair_b"))
        new_module.crosshair_tos = Vector(ScrW()/2,ScrH()/2) --eye_trace.HitPos:ToScreen()

        if eye_trace.Entity:IsNPC() then new_module.crosshair_color = Color(GetConVarNumber("crosshair_ally_r"),GetConVarNumber("crosshair_ally_g"),GetConVarNumber("crosshair_ally_b")) end
        if IsValid(eye_trace.Entity) and IsEnemyEntityName(eye_trace.Entity:GetClass()) then new_module.crosshair_color = Color(GetConVarNumber("crosshair_enemy_r"),GetConVarNumber("crosshair_enemy_g"),GetConVarNumber("crosshair_enemy_b")) end

        new_module.spread = 4
        local punch_vel = Vector(LocalPlayer():GetViewPunchVelocity().pitch,LocalPlayer():GetViewPunchVelocity().yaw,LocalPlayer():GetViewPunchVelocity().roll):Length()

        new_module.spread = new_module.spread + ((LocalPlayer():GetVelocity():Length()/300) + punch_vel/5) * 15
        new_module.spread = math.Clamp(new_module.spread,4,70)

        outlined_box(new_module.crosshair_tos.x,new_module.crosshair_tos.y,GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_thickness"),new_module.crosshair_color,Color(0,0,0,255))
        outlined_box(new_module.crosshair_tos.x + new_module.spread_smooth + GetConVarNumber("crosshair_bar_height")/2,new_module.crosshair_tos.y,GetConVarNumber("crosshair_bar_height"),GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_thickness"),new_module.crosshair_color,Color(0,0,0,255))
        outlined_box(new_module.crosshair_tos.x - new_module.spread_smooth - GetConVarNumber("crosshair_bar_height")/2,new_module.crosshair_tos.y,GetConVarNumber("crosshair_bar_height"),GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_thickness"),new_module.crosshair_color,Color(0,0,0,255))
        outlined_box(new_module.crosshair_tos.x,new_module.crosshair_tos.y + new_module.spread_smooth + GetConVarNumber("crosshair_bar_height")/2,GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_bar_height"),GetConVarNumber("crosshair_thickness"),new_module.crosshair_color,Color(0,0,0,255))
        outlined_box(new_module.crosshair_tos.x,new_module.crosshair_tos.y - new_module.spread_smooth - GetConVarNumber("crosshair_bar_height")/2,GetConVarNumber("crosshair_bar_size"),GetConVarNumber("crosshair_bar_height"),GetConVarNumber("crosshair_thickness"),new_module.crosshair_color,Color(0,0,0,255))
    end
end

function new_module:update()
    if GetConVarString("crosshair_reset") == "true" then
        GetConVar("crosshair_show"):SetFloat(1)
        
        GetConVar("crosshair_r"):SetFloat(70)
        GetConVar("crosshair_g"):SetFloat(255)
        GetConVar("crosshair_b"):SetFloat(70)

        GetConVar("crosshair_enemy_r"):SetFloat(255)
        GetConVar("crosshair_enemy_g"):SetFloat(70)
        GetConVar("crosshair_enemy_b"):SetFloat(70)

        GetConVar("crosshair_ally_r"):SetFloat(70)
        GetConVar("crosshair_ally_g"):SetFloat(255)
        GetConVar("crosshair_ally_b"):SetFloat(255)

        GetConVar("crosshair_thickness"):SetFloat(1)
        GetConVar("crosshair_bar_height"):SetFloat(8)
        GetConVar("crosshair_bar_size"):SetFloat(4)
        GetConVar("crosshair_reset"):SetString("false")
    end
end

return {module=new_module}