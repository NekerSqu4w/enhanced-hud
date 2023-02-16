local new_module = {}

new_module.name = "VGUI example"
new_module.id = "vgui_example"
new_module.version = "1.0"

function new_module:init()
    --include("autorun/menu/vgui/VGUI_generator.lua")
    --vgui.Create("vgui_example")
end

function new_module:hud()
end

function new_module:update()
end

return {module=new_module}