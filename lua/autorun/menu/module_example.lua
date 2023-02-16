local new_module = {}

new_module.name = "Module Example"
new_module.id = "example"
new_module.version = "1.0"

function new_module:init()
end

function new_module:hud()
end

function new_module:update()
end

return {module=new_module}