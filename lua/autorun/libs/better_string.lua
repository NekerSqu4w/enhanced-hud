function format_data(data)
    local new_data = ""
    if type(data) == "table" then
        new_data = new_data..data.r..", "..data.g..", "..data.b..", "..data.a
    end
    if type(data) == "Vector" or type(data) == "Angle" then
        new_data = ""
        for id, val in pairs(data:ToTable()) do
            new_data = new_data .. math.floor(val) .. ", "
        end
    end
    return new_data
end

function format_higher(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end