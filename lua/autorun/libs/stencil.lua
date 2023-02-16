function stencil_mask()
    render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(3)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(3)
end

function stencil_pop()
    render.SetStencilEnable(false)
end