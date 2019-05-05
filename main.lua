_util = nil

local swordgen = nil
local sword = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    _util = require("lib.util")
    swordgen = require("src.swordgen")
    swordgen.toggle_debug()
    swordgen:generate()

    love.graphics.setBackgroundColor(0.15, 0.2, 0.4)
    love.graphics.setFont(love.graphics.newFont(32))
end

function love.update(dt)
end

function love.draw()
    swordgen:draw()
end

function love.keypressed(key)
    if key == "space" then
        swordgen:generate()
    elseif key == "escape" then
        love.event.quit()
    end
end
