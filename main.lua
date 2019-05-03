_util = nil

local swordgen = nil
local sword = nil

function love.load()
    _util = require("lib.util")
    swordgen = require("src.swordgen")
end

function love.update(dt)
end

function love.draw()
    if sword then
        local counter = 0
        love.graphics.setColor(1, 0, 0)
        for k, component in pairs(sword) do
            love.graphics.print(
                k .. ": " .. component.name,
                love.graphics.getWidth() / 2,
                love.graphics.getHeight() / 3 + counter * 20
            )
            counter = counter + 1
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        sword = swordgen:generate()
    elseif key == "escape" then
        love.event.quit()
    end
end
