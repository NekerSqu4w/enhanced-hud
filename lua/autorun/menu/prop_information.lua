local new_module = {}

new_module.name = "Prop informations"
new_module.id = "prop_informations"
new_module.version = "1.0"

include("../libs/better_render.lua")
include("../libs/better_string.lua")

function new_module:init()
    surface.CreateFont("prop_info", {font = "FontAwesome",size = 18,antialias = true,shadow = true})

    CreateClientConVar("prop_info_show", 1, true, false)
    CreateClientConVar("prop_info_r", 255, true, false)
    CreateClientConVar("prop_info_g", 200, true, false)
    CreateClientConVar("prop_info_b", 40, true, false)
    CreateClientConVar("prop_info_reset", "false", true, false)
end

function new_module:hud()
    local eye_trace = LocalPlayer():GetEyeTrace()

    local filter_class = {
        ["class C_BaseEntity"] = true,
        ["prop_door_rotating"] = false,
        ["prop_dynamic"] = false,
        ["func_rotating"] = false,
        ["func_door"] = false
    }

    if eye_trace.Entity and eye_trace.Entity:IsValid() and eye_trace.HitWorld == false and GetConVarNumber("prop_info_show") == 1 then
        if filter_class[eye_trace.Entity:GetClass()] then return end

        local mat = eye_trace.Entity:GetMaterial()
        if mat == "" then mat = eye_trace.Entity:GetMaterials()[1] end
        if mat == nil then mat = "Cannot get material" end

        local owner_name = LocalPlayer():GetName()
        if eye_trace.Entity:GetOwner():IsValid() then owner_name = tostring(eye_trace.Entity:GetOwner()) end

        local prop_info = {
            {value_type="text",type=format_higher(language.GetPhrase("addons.entity")) .. ": ",info=eye_trace.Entity:GetClass().." ["..eye_trace.Entity:EntIndex().."]"},
            {value_type="text",type=format_higher(language.GetPhrase("owner")) .. ": ",info=owner_name},
            {value_type="text",type=format_higher(language.GetPhrase("models")) .. ": ",info=eye_trace.Entity:GetModel()},
            {value_type="text",type="",info=""},
            {value_type="table",type="Pos: ",info=format_data(eye_trace.Entity:GetPos())},
            {value_type="table",type="Ang: ",info=format_data(eye_trace.Entity:EyeAngles())},
            {value_type="table",type=format_higher(language.GetPhrase("size")) .. ": ",info=format_data((-eye_trace.Entity:OBBMins() + eye_trace.Entity:OBBMaxs()))},
            {value_type="text",type="",info=""},
            {value_type="table",type=format_higher(language.GetPhrase("color")) .. ": ",info=format_data(eye_trace.Entity:GetColor())},
            {value_type="text",type=format_higher(language.GetPhrase("materials")) .. ": ",info=mat},
            {value_type="text",type="",info=""},
            {value_type="bool",type="Collide: ",info=eye_trace.Entity:GetCollisionGroup() == 0},
            {value_type="bool",type="Breakable: ",info=eye_trace.Entity:Health() > 0}
        }

        if eye_trace.Entity:Health() > 0 then
            table.insert(prop_info,{value_type="health",type=format_higher(language.GetPhrase("health")) .. ": ",info=eye_trace.Entity:Health() .. " / " .. eye_trace.Entity:GetMaxHealth()})
        end

        local text_data = {}
        local write_info = ""

        for i, info in pairs(prop_info) do
            text_data[#text_data+1] = {}
            text_data[#text_data].text = info.type
            text_data[#text_data].color = Color(GetConVarNumber("prop_info_r"),GetConVarNumber("prop_info_g"),GetConVarNumber("prop_info_b"))

            write_info = write_info .. info.type

            if info.value_type == "text" then
                text_data[#text_data+1] = {}
                text_data[#text_data].text = info.info .. "\n"
                text_data[#text_data].color = Color(255,255,255)
            elseif info.value_type == "table" then
                for id, num in pairs(string.Split(info.info," ")) do
                    text_data[#text_data+1] = {}
                    text_data[#text_data].text = num

                    if id == 1 then
                        text_data[#text_data].color = Color(255,120,120)
                    elseif id == 2 then
                        text_data[#text_data].color = Color(120,255,120)
                    elseif id == 3 then
                        text_data[#text_data].color = Color(120,120,255)
                    elseif id == 4 then
                        text_data[#text_data].color = Color(255,255,255)
                    end
                end

                text_data[#text_data].text = text_data[#text_data].text .. "\n"
            elseif info.value_type == "bool" then
                text_data[#text_data+1] = {}
                text_data[#text_data].text = string.upper(language.GetPhrase(tostring(info.info))) .. "\n"
                if info.info then
                    text_data[#text_data].color = Color(0,255,0)
                else
                    text_data[#text_data].color = Color(255,0,0)
                end
            elseif info.value_type == "health" then
                text_data[#text_data+1] = {}
                text_data[#text_data].text = info.info .. "\n"

                local health = tonumber(string.Split(info.info," / ")[1])
                local max = tonumber(string.Split(info.info," / ")[2])
                local health_ratio = health / max

                text_data[#text_data].color = Color(255 - health_ratio * 255,health_ratio * 255,0)
            end

            write_info = write_info .. tostring(info.info) .. "\n"
        end

        write_info = string.sub(write_info, 0, #write_info-1)
        local info_width, info_height = draw.SimpleText(write_info, "prop_info", -1500, -1500, color_white)
        info_width = info_width + 20
        info_height = info_height + 20

        classic_box(8,ScrW()-info_width,64,info_width,info_height,Color(0,0,0,120),Color(GetConVarNumber("prop_info_r"),GetConVarNumber("prop_info_g"),GetConVarNumber("prop_info_b")))
        colored_text(ScrW()-info_width + 10, 64+10,text_data)
    end
end

function new_module:update()
    if GetConVarString("prop_info_reset") == "true" then
        GetConVar("prop_info_show"):SetFloat(1)
        GetConVar("prop_info_r"):SetFloat(255)
        GetConVar("prop_info_g"):SetFloat(200)
        GetConVar("prop_info_b"):SetFloat(40)
        GetConVar("prop_info_reset"):SetString("false")
    end
end

return {module=new_module}