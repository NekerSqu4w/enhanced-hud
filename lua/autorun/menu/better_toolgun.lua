local new_module = {}

new_module.name = "Better toolgun"
new_module.id = "better_toolgun"
new_module.version = "1.0"
new_module.block_animation = {}

include("../libs/better_render.lua")

function new_module:init()
    surface.CreateFont("ToolGun", {font = "FontAwesome",size = 35,antialias = true,shadow = true})
end

function new_module:hud()
    new_module.TOOL = LocalPlayer():GetTool()
    if new_module.TOOL then else return end
    --if new_module.TOOL.DrawToolScreen then else return end

    function new_module.TOOL:DrawToolScreen(width, height)
        surface.SetDrawColor(Color(255/3, 200/3, 40/3))
        surface.DrawRect(0, 0, width, height)
 
        surface.SetDrawColor(Color(255, 200, 40))
        surface.DrawRect(0, height-6, width, 6)
        surface.DrawRect(0, 0, width, 6)

        draw.SimpleText(""..self.Name, "ToolGun", width/2, height/2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(70, 255, 70))
        for _, block in pairs(new_module.block_animation) do
            surface.DrawRect((block.move/100) * width - 1, height - block.size, 2, block.size)

            block.move = block.move - 1
            if block.move < 0 then table.remove(new_module.block_animation,_) end
        end
    end
end

function new_module:update()
    table.insert(new_module.block_animation,{move=100,size=6 + engine.ServerFrameTime() * 256})
end

return {module=new_module}