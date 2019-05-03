local swordgen = {}

local _debug = false
local _current_sword = nil

-- [HELPERS]

function coordinates(x, y)
    return {x = x, y = y}
end

function choose(...)
    local args = {...}
    return args[love.math.random(1, #args)]
end

-- [CONSTANTS]

-- each type of sprite the same dimensions (for now). alternatively they have their own pivot points
local COMPONENT_SPRITE_WIDTH = 16
local COMPONENT_SPRITE_HEIGHT = 16

local BLADES_SPRITESHEET = love.graphics.newImage("resource/blades.png")
local HILTS_SPRITESHEET = love.graphics.newImage("resource/hilts.png")
local HANDLES_SPRITESHEET = love.graphics.newImage("resource/handles.png")

-- TODO: figure out how to anchor. maybe supporting data file/table for each individual sprite? (could do all the same for now)
-- local BLADE_SPRITE_ANCHOR = coordinates(SPRITE_WIDTH / 2, SPRITE_HEIGHT) -- bottom centre
-- local HILT_SPRITE_ANCHOR = coordinates(T)

function create_component_quad(x, y)
    return love.graphics.newQuad(
        x,
        y,
        COMPONENT_SPRITE_WIDTH,
        COMPONENT_SPRITE_HEIGHT,
        BLADES_SPRITESHEET:getWidth(),
        BLADES_SPRITESHEET:getHeight()
    )
end

local HANDLES = {
    {
        name = "1",
        quad = create_component_quad(0, 0)
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0)
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0)
    }
}

local HILTS = {
    {
        name = "1",
        quad = create_component_quad(0, 0)
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0)
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0)
    }
}

local BLADES = {
    {
        name = "1",
        quad = create_component_quad(0, 0)
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0)
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0)
    },
    {
        name = "4",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 3, 0)
    }
}

-- [LOGIC]

function swordgen:toggle_debug()
    _debug = not _debug
end

function swordgen:generate()
    local new_sword = {
        hilt = choose(unpack(HILTS)),
        blade = choose(unpack(BLADES)),
        handle = choose(unpack(HANDLES))
    }

    -- TODO: Combine the component sprites into a single point using anchor points

    _current_sword = new_sword
end

function swordgen:draw()
    if _debug and _current_sword then
        local counter = 0
        local sx, sy = 16, 16

        for key, component in pairs(_current_sword) do
            love.graphics.setColor(1, 1, 1)
            if key == "blade" then
                love.graphics.draw(
                    BLADES_SPRITESHEET,
                    _current_sword.blade.quad,
                    love.graphics.getWidth() / 3 - COMPONENT_SPRITE_WIDTH / 2 * sx,
                    love.graphics.getHeight() / 2 - COMPONENT_SPRITE_HEIGHT / 2 * sy,
                    0,
                    sx,
                    sy
                )
            elseif key == "hilt" then
                love.graphics.draw(
                    HILTS_SPRITESHEET,
                    _current_sword.hilt.quad,
                    love.graphics.getWidth() / 2 - COMPONENT_SPRITE_WIDTH / 2 * sx,
                    love.graphics.getHeight() / 2 - COMPONENT_SPRITE_HEIGHT / 2 * sy,
                    0,
                    sx,
                    sy
                )
            elseif key == "handle" then
                love.graphics.draw(
                    HANDLES_SPRITESHEET,
                    _current_sword.handle.quad,
                    love.graphics.getWidth() * 2 / 3 - COMPONENT_SPRITE_WIDTH / 2 * sx,
                    love.graphics.getHeight() / 2 - COMPONENT_SPRITE_HEIGHT / 2 * sy,
                    0,
                    sx,
                    sy
                )
            end
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(key .. ": " .. component.name, 50, 50 + counter * 50)
            counter = counter + 1
        end
    end
end

function swordgen:update(dt)
end

return swordgen
