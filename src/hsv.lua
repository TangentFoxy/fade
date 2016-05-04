local function hue_to_rgb(hue)
    local c = 1
    local x = 1 - math.abs((hue / 60) % 2 - 1)
    local m = 0

    local r, g, b

    if hue < 60 then
        r = c
        g = x
        b = 0
    elseif hue < 120 then
        r = x
        g = c
        b = 0
    elseif hue < 180 then
        r = 0
        g = c
        b = x
    elseif hue < 240 then
        r = 0
        g = x
        b = c
    elseif hue < 300 then
        r = x
        g = 0
        b = c
    else
        r = c
        g = 0
        b = x
    end

    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)

    return r, g, b
end

return hue_to_rgb
