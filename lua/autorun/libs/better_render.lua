function outlined_box(x,y,w,h,thickness,color,color2)
    surface.SetDrawColor(color)
    surface.DrawRect(x-w/2,y-h/2,w,h)

    surface.SetDrawColor(color2)
    surface.DrawOutlinedRect(x-w/2,y-h/2,w,h,thickness)
end

function classic_box(r,x,y,w,h,color,color2)
    draw.RoundedBoxEx(r, x, y, w, h, color, true, true, false, false)
    surface.SetDrawColor(color2)
    surface.DrawRect(x,y+h,w,4)
end

function colored_text(x,y,text_data)
    local new_width, new_height = 0, 0
    local max_width, max_height = 0, 0

    for i, text in pairs(text_data) do
        local info_width, info_height = draw.SimpleText(text.text .. " ", "prop_info", -1500, -1500, text.color)

        draw.DrawText(text.text, "prop_info", x + new_width, y + new_height/2, text.color)
        new_width = new_width + info_width

        if string.sub(text.text,#text.text,#text.text+1) == "\n" then
            new_height = new_height + info_height
            new_width = 0
        end

        if new_width > max_width then max_width = new_width end
        if new_height > max_height then max_height = new_height end
    end
    return max_width,max_height
end