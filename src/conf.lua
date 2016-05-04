function love.conf(t)
    t.title = "FADE"
    t.console = true --tmp

    local w, h = love.graphics.getDesktopDimensions()
    t.window.width = w
    t.window.height = h
    t.window.borderless = true
end
