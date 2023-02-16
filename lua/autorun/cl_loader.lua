
if CLIENT then
    local addons = {}
    addons.version = "1.0"

    local hide = {
        ["CHudCrosshair"] = true
	}

    print("\n/==========[Enhanced HUD]==========\\ \nInitialized !")
    --Import and Init all module
    local module_load = {}
    local get_module = {}
    function reload_module()
        local module_, _ = file.Find("addons/Enhanced HUD/lua/autorun/menu/*", "GAME")
        for _, file_path in pairs(module_) do
            module_load[_] = include("menu/" .. file_path)
            module_load[_].module.init()
            module_load[_].module.inited = true
            get_module[file_path] = module_load[_].module

            print("[Enhanced HUD] Loaded module 'menu/" .. file_path .. "' (ver. " .. module_load[_].module.version .. ")")
        end

        setup_options()
    end

	hook.Add("HUDShouldDraw", "HideHUD", function(name)
		if(hide[name]) then return false end
	end)

    --Update HUD from module
    hook.Add("HUDPaint","draw something on hud",function()
        for i=1, #module_load do
            if module_load[i].module.inited then
                module_load[i].module.hud()
            end
        end
    end)

    --Update from servertick
    hook.Add("Think","update from servertick",function()
        for i=1, #module_load do
            if module_load[i].module.inited then
                module_load[i].module.update()
            end
        end

        hide["CHudCrosshair"] = tobool(GetConVarNumber("crosshair_show"))
    end)

    --Command handler
    hook.Add("OnPlayerChat", "handle command", function(ply, strText, bTeam, bDead) 
        if(ply != LocalPlayer()) then return end

        local sp_text = strText:Split(" ")
        local cmd = string.lower(sp_text[1])
        local data = string.sub(strText,#cmd+2,#strText)

        if(cmd == "!ping") then
            ply:ChatPrint("pong !")
            return true
        end
    end)

    --Setup options menu
    function setup_options()
        hook.Add("AddToolMenuCategories", "enhanced hud", function()
            spawnmenu.AddToolCategory("Options", "Enhanced_HUD", "#Enhanced Hud")
        end)

        hook.Add("PopulateToolMenu", "enhanced hud", function()
            spawnmenu.AddToolMenuOption("Options", "Enhanced_HUD", "Changelog", "#Changelog", "", "", function(pnl)
                pnl:ClearControls()
                pnl:AddControl("label",{text="Changelog soon !"})
            end)

            spawnmenu.AddToolMenuOption("Options", "Enhanced_HUD", "module/better_crosshair.lua", "#module/better_crosshair.lua", "", "", function(pnl)
                pnl:ClearControls()
                pnl:AddControl("label",{text=get_module["better_crosshair.lua"].name .. " @ ver. " .. get_module["better_crosshair.lua"].version})

                pnl:AddControl("label",{text="//----Crosshair settings----\\"})
                pnl:AddControl("checkbox",{label="Show crosshair",command="crosshair_show"})
                pnl:AddControl("color",{label="Crosshair color:",red="crosshair_r",green="crosshair_g",blue="crosshair_b"})
                pnl:AddControl("color",{label="Crosshair enemy color:",red="crosshair_enemy_r",green="crosshair_enemy_g",blue="crosshair_enemy_b"})
                pnl:AddControl("color",{label="Crosshair ally color:",red="crosshair_ally_r",green="crosshair_ally_g",blue="crosshair_ally_b"})
                pnl:AddControl("slider",{label="Bar size",command="crosshair_bar_size",min=4,max=8})
                pnl:AddControl("slider",{label="Bar height",command="crosshair_bar_height",min=4,max=32})
                pnl:AddControl("slider",{label="Border thickness",command="crosshair_thickness",min=0,max=4})
                pnl:AddControl("button",{label="Reset settings",command="crosshair_reset true"})
            end)

            spawnmenu.AddToolMenuOption("Options", "Enhanced_HUD", "module/prop_information.lua", "#module/prop_information.lua", "", "", function(pnl)
                pnl:ClearControls()
                pnl:AddControl("label",{text=get_module["prop_information.lua"].name .. " @ ver. " .. get_module["prop_information.lua"].version})

                pnl:AddControl("label",{text="//----Prop informations settings----\\"})
                pnl:AddControl("checkbox",{label="Show prop informations",command="prop_info_show"})
                pnl:AddControl("color",{label="Informations color:",red="prop_info_r",green="prop_info_g",blue="prop_info_b"})
                pnl:AddControl("button",{label="Reset settings",command="prop_info_reset true"})
            end)
        end)
    end

    function printColor(...)
        chat.AddText(...)
    end
    --printColor(Color(255, 0, 255), "Test")

    reload_module()
end