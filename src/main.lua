local lg = love.graphics
local lm = love.mouse

local left
local major, minor, revision = love.getVersion()
if (major == 0) and (minor == 10) then
    left = 1
else
    left = "l"
end

local point = {}
local lines = {}

local function dist(x1, y1, x2, y2)
    local X = x2 - x1
    local Y = y2 - y1
    return math.sqrt(X*X + Y*Y)
end

local delta, rate = 0, 1/20
function love.update(dt)
    if lm.isDown(left) then
        local x, y = lm.getPosition()
        if dist(point.x, point.y, x, y) > 1 then
            table.insert(lines, {gray = 255, alpha = 255, x = x, y = y})
            point.x = x
            point.y = y
        end
    end

    delta = delta + dt
    if delta >= rate then
        delta = delta - rate

        for i = 1, #lines do
            lines[i].gray = lines[i].gray - 1
        end

        while lines[1] and lines[1].gray == 0 do
            table.remove(lines, 1)
        end
    end
end

function love.draw()
    for i = 1, #lines - 1 do
        lg.setColor(lines[i].gray, lines[i].gray, lines[i].gray, lines[i].alpha)
        lg.line(lines[i].x, lines[i].y, lines[i+1].x, lines[i+1].y)
    end
end

---[[
function love.mousepressed(x, y)
    point = {x = x, y = y}
end
--]]

function love.mousereleased(x, y)
    table.insert(lines, {gray = 0, alpha = 0, x = x, y = y})
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
