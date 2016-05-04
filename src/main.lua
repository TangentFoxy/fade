local hsv = require "hsv"
local lg = love.graphics
local lm = love.mouse

local left
local major, minor, revision = love.getVersion()
if (major == 0) and (minor == 10) then
    left = 1
    right = 2
else
    left = "l"
    right = "r"
end

local point = {}
local lines = {}
local hue = 60
local blacknwhite = false

function love.load()
    local w, h = love.window.getDesktopDimensions()
    love.window.setMode(w, h, {borderless = true})
end

local function dist(x1, y1, x2, y2)
    local X = x2 - x1
    local Y = y2 - y1
    return math.sqrt(X*X + Y*Y)
end

local delta, rate = 0, 1/20
local swatch = 4
function love.update(dt)
    --print(hue) --tmp
    if swatch > 0 then
        swatch = swatch - dt
    end

    if lm.isDown(left) then
        local x, y = lm.getPosition()
        if dist(point.x, point.y, x, y) > 1 then
            local r, g, b
            if lm.isDown(right) or blacknwhite then
                r, g, b = 255, 255, 255
            else
                r, g, b = hsv(hue)
            end
            table.insert(lines, {red = r, green = g, blue = b, alpha = 255, x = x, y = y})
            point.x = x
            point.y = y
        end
    end

    delta = delta + dt
    if delta >= rate then
        delta = delta - rate

        for i = 1, #lines do
            if lines[i].alpha > 0 then
                lines[i].alpha = lines[i].alpha - 1
            end
        end

        while lines[1] and lines[1].alpha == 0 do
            table.remove(lines, 1)
        end
    end
end

function love.draw()
    for i = 1, #lines - 1 do
        lg.setColor(lines[i].red, lines[i].green, lines[i].blue, lines[i].alpha)
        lg.line(lines[i].x, lines[i].y, lines[i+1].x, lines[i+1].y)
    end

    if (swatch > 0) and (not blacknwhite) then
        local r, g, b = hsv(hue)
        lg.setColor(r, g, b, swatch * 63)
        lg.rectangle("fill", 0, 0, lg.getWidth()/10, lg.getWidth()/10)
    end
end

---[[
function love.mousepressed(x, y, button)
    if button == left then
        point = {x = x, y = y}
    elseif button == "wu" then
        hue = hue - 30
        if hue < 0 then
            hue = 360
        end
        swatch = 4
    elseif button == "wd" then
        hue = hue + 30
        if hue > 360 then
            hue = 0
        end
        swatch = 4
    end
end
--]]

function love.mousereleased(x, y, button)
    if button == left then
        table.insert(lines, {red = 0, green = 0, blue = 0, alpha = 0, x = x, y = y})
    end
end

function love.wheelmoved(x, y)
    if y < 0 then
        hue = hue - 30
        if hue < 0 then
            hue = 360
        end
        swatch = 4
    elseif y > 0 then
        hue = hue + 30
        if hue > 360 then
            hue = 0
        end
        swatch = 4
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "p" then
        local screenshot = lg.newScreenshot()
        screenshot:encode("png", os.time() .. ".png")
    end

    if key == "b" then
        blacknwhite = not blacknwhite
        if not blacknwhite then
            swatch = 4
        end
    end

    if key == "c" then
        lines = {}
    end
end
