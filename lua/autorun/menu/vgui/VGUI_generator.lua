surface.CreateFont("derma_title", {
    font = "Arial",
    extended = true,
    size = 20
})

local PANEL = {}
function PANEL:Init()
    self:SetTitle("")
    self:SetPos(ScrW() - 50 - 640,50)
    self:ShowCloseButton(true)
    self:SetDraggable(true)
    self:SetSizable(true)
    self:SetSize(640,410)
    self:SetMinWidth(640)
    self:SetMinHeight(410)
    self:MakePopup()

    self.browser = vgui.Create("DFileBrowser", self)
    self.browser:Dock(FILL)

    self.browser:SetPath("GAME")
    self.browser:SetBaseFolder("data")
    self.browser:SetOpen(true)
    self.browser:SetCurrentFolder("persist")


    self.data_pnl = vgui.Create("DFrame")
    self.data_pnl:SetTitle("")
    self.data_pnl:SetPos(ScrW() - 50 - 640,50 + 420)
    self.data_pnl:ShowCloseButton(true)
    self.data_pnl:SetDraggable(true)
    self.data_pnl:SetSizable(true)
    self.data_pnl:SetSize(640,410)
    self.data_pnl:SetMinWidth(640)
    self.data_pnl:SetMinHeight(410)
    self.data_pnl:MakePopup()

    local data_text = vgui.Create("DLabel",self.data_pnl)
    data_text:SetText("Waiting for data..")
    data_text:Dock(FILL)

    --local img_bg = vgui.Create("DImage",self.data_pnl)
    --img_bg:Dock(FILL)

    self.data_pnl.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,200))
        draw.RoundedBox(4, 0, 0, w, 26, Color(50,50,50,255))
        draw.SimpleText("Data viewer", "derma_title", 10, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end


    function self.browser:OnSelect(path, pnl)
        --img_bg:SetImage(path)
        data_text:SetText(file.Read(path, "GAME"))
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,200))
    draw.RoundedBox(4, 0, 0, w, 26, Color(50,50,50,255))
    draw.SimpleText("Data list", "derma_title", 10, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

vgui.Register("vgui_example", PANEL, "DFrame")