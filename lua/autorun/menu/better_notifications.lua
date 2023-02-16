local new_module = {}

new_module.name = "Better notifications"
new_module.id = "better_notifications"
new_module.version = "1.0"

include("../libs/better_render.lua")
include("../libs/stencil.lua")

function new_module:init()
    --Override default gmod notifications
    new_module.mat = {}
    new_module.mat[0] = Material("vgui/notices/generic", "noclamp smooth")
    new_module.mat[1] = Material("vgui/notices/error", "noclamp smooth")
    new_module.mat[2] = Material("vgui/notices/undo", "noclamp smooth")
    new_module.mat[3] = Material("vgui/notices/hint", "noclamp smooth")
    new_module.mat[4] = Material("vgui/notices/cleanup", "noclamp smooth")
    new_module.mat[5] = Material("icon16/drive_go.png", "noclamp smooth")

    new_module.notification_list = {}
    function notification.AddLegacy(text, type, length)
        table.insert(new_module.notification_list,{spawn_at=CurTime(),type="legacy",settings={text=text,type=type,length=length}})
    end

    function notification.AddProgress(id, strText, frac)
        if new_module.notification_list[id] then
            new_module.notification_list[id].settings.text = strText
            new_module.notification_list[id].settings.frac = frac or -1
        else
            new_module.notification_list[id] = {spawn_at=CurTime(),slide=-0.2,frac_smooth=0,type="progress",settings={id=id,text=strText,length=1500000,frac=frac or -1}}
        end
    end

    function notification.Kill(id)
        new_module.notification_list[id] = nil
    end

    function add_notif()
        for i=0, 4 do
            notification.AddLegacy("I loaded enhanced hud ", i, math.random(5,10))
        end

        local i = 0
        timer.Create("loop_load",1,10,function()
            i = i + 0.1
            notification.AddProgress("loading", "Waiting for something",i)
        end)

        notification.AddProgress("loading", "Waiting for something")
        notification.AddProgress("loading2", "Waiting for something")
        
        timer.Simple(12, function()
            notification.Kill("loading")
            notification.Kill("loading2")
        end)
    end
    add_notif()
end

function new_module:hud()
    new_module.notifs_id = 0
    for id, notif in pairs(new_module.notification_list) do
        local progress = (CurTime() - notif.spawn_at) / notif.settings.length

        local notif_width, notif_height = draw.SimpleText(notif.settings.text, "prop_info", -1500, -1500, Color(255,255,255))
        notif_height = 40

        local out_col = Color(70,255,70) --progress notifications
        if notif.type == "legacy" then
            if notif.settings.type == 0 then out_col = Color(255,200,70) end
            if notif.settings.type == 1 then out_col = Color(255,70,70) end
            if notif.settings.type == 2 then out_col = Color(0,150,255) end
            if notif.settings.type == 3 then out_col = Color(0,150,255) end
            if notif.settings.type == 4 then out_col = Color(0,150,255) end
        end

        draw.RoundedBoxEx(8, ScrW() - notif_width - 35 - notif_height,ScrH() - 180 - new_module.notifs_id * (notif_height + 10),notif_width+20 + notif_height,notif_height,Color(0,0,0,120),true,true,false,false)
        draw.DrawText(notif.settings.text, "prop_info", ScrW() - notif_width - 30,ScrH() - 180 + notif_height/2 - 10 - new_module.notifs_id * (notif_height + 10), Color(255,255,255))

        surface.SetMaterial(new_module.mat[notif.settings.type] or new_module.mat[5])
        surface.SetDrawColor(Color(255, 255, 255))
        surface.DrawTexturedRect(ScrW() - notif_width - 35 - notif_height + 5,ScrH() - 180 + 5 - new_module.notifs_id * (notif_height + 10), notif_height - 10, notif_height - 10)

        surface.SetDrawColor(Color(out_col.r/3,out_col.g/3,out_col.b/3,255))
        surface.DrawRect(ScrW() - notif_width - 35 - notif_height,ScrH() - 180 + notif_height - new_module.notifs_id * (notif_height + 10),notif_width+20 + notif_height,4,2)

        if notif.type == "legacy" then
            surface.SetDrawColor(out_col)
            surface.DrawRect(ScrW() - notif_width - 35 - notif_height,ScrH() - 180 + notif_height - new_module.notifs_id * (notif_height + 10),(1-progress) * (notif_width+20 + notif_height),4,2)
        elseif notif.type == "progress" then
            notif.frac_smooth = Lerp(0.05,notif.frac_smooth,notif.settings.frac)
            
            progress = notif.frac_smooth

            surface.SetDrawColor(out_col)
            if notif.settings.frac == -1 then
                notif.slide = notif.slide + 0.01
                if notif.slide >= 1.4 then notif.slide = -0.4 end

                stencil_mask()
                surface.DrawRect(ScrW() - notif_width - 35 - notif_height,ScrH() - 180 + notif_height - new_module.notifs_id * (notif_height + 10),(notif_width+20 + notif_height),4,2)
                surface.DrawRect(ScrW() - notif_width - 35 - 30 + (notif.slide * notif_width),ScrH() - 180 + notif_height - new_module.notifs_id * (notif_height + 10),40,6)
                stencil_pop()
            else
                surface.DrawRect(ScrW() - notif_width - 35 - notif_height,ScrH() - 180 + notif_height - new_module.notifs_id * (notif_height + 10),progress * (notif_width+20 + notif_height),4,2)
            end
        end

        if notif.type == "legacy" and (CurTime() - notif.spawn_at) >= notif.settings.length then table.remove(new_module.notification_list,id) end
        new_module.notifs_id = new_module.notifs_id + 1
    end
end

function new_module:update()
end

return {module=new_module}