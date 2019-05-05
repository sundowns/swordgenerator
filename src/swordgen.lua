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
        quad = create_component_quad(0, 0),
        fixtures = {
            hilt = coordinates(7, 9)
        }
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0),
        fixtures = {
            hilt = coordinates(7, 9)
        }
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0),
        fixtures = {
            hilt = coordinates(7, 9)
        }
    },
    {
        name = "4",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 3, 0),
        fixtures = {
            hilt = coordinates(7, 6)
        }
    }
}

local HILTS = {
    {
        name = "1",
        quad = create_component_quad(0, 0),
        fixtures = {
            handle = coordinates(7, 14),
            blade = coordinates(7, 9)
        }
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0),
        fixtures = {
            handle = coordinates(7, 13),
            blade = coordinates(7, 10)
        }
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0),
        fixtures = {
            handle = coordinates(7, 13),
            blade = coordinates(7, 10)
        }
    }
}

local BLADES = {
    {
        name = "1",
        quad = create_component_quad(0, 0),
        fixtures = {
            hilt = coordinates(8, 15)
        }
    },
    {
        name = "2",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH, 0),
        fixtures = {
            hilt = coordinates(8, 15)
        }
    },
    {
        name = "3",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 2, 0),
        fixtures = {
            hilt = coordinates(8, 15)
        }
    },
    {
        name = "4",
        quad = create_component_quad(COMPONENT_SPRITE_WIDTH * 3, 0),
        fixtures = {
            hilt = coordinates(8, 15)
        }
    }
}

-- [LOGIC]

function swordgen:toggle_debug()
    _debug = not _debug
end

function swordgen:create_new()
    return {
        components = {
            hilt = choose(unpack(HILTS)),
            blade = choose(unpack(BLADES)),
            handle = choose(unpack(HANDLES))
        },
        canvas = nil
    }
end

function swordgen:combine(sword)
    local canvas = love.graphics.newCanvas(COMPONENT_SPRITE_WIDTH, COMPONENT_SPRITE_HEIGHT * 3) -- 16x48 atm
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1, 1, 1)
    -- draw handle at the bottom
    love.graphics.draw(
        HANDLES_SPRITESHEET,
        sword.components.handle.quad,
        0,
        canvas:getHeight() - COMPONENT_SPRITE_HEIGHT
    )

    -- Draw hilt (bottom pivot) above handle (top pivot)
    local hilt_offset =
        coordinates(
        sword.components.handle.fixtures.hilt.x - sword.components.hilt.fixtures.handle.x,
        sword.components.handle.fixtures.hilt.y - sword.components.hilt.fixtures.handle.y
    )
    love.graphics.draw(
        HILTS_SPRITESHEET,
        sword.components.hilt.quad,
        hilt_offset.x,
        canvas:getHeight() - COMPONENT_SPRITE_HEIGHT + hilt_offset.y
    )

    -- Draw blade (bottom pivot) above hilt (top pivot)
    local blade_offset =
        coordinates(
        sword.components.hilt.fixtures.blade.x - sword.components.blade.fixtures.hilt.x,
        sword.components.hilt.fixtures.blade.y - sword.components.blade.fixtures.hilt.y
    )

    love.graphics.draw(
        BLADES_SPRITESHEET,
        sword.components.hilt.quad,
        blade_offset.x,
        canvas:getHeight() - COMPONENT_SPRITE_HEIGHT + hilt_offset.y + blade_offset.y
    )

    love.graphics.setCanvas()

    sword.canvas = canvas
    return sword
end

function swordgen:generate()
    local new_sword = self:create_new()
    new_sword = self:combine(new_sword)

    -- TODO: Anchor joining -
    -- * Specify anchors for each component (blade x1, hilt x2, handle x1).
    -- * in order of blade -> hilt1, hilt2 -> handle, attach each anchor pair on a canvas (calculate the offset & translate)

    -- local BLADE_SPRITE_ANCHOR = coordinates(SPRITE_WIDTH / 2, SPRITE_HEIGHT) -- bottom centre
    -- local HILT_SPRITE_ANCHOR = coordinates(T)

    _current_sword = new_sword
end

function swordgen:draw()
    if _current_sword.canvas then
        local sx, sy = 12, 12
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            _current_sword.canvas,
            love.graphics.getWidth() / 2 - _current_sword.canvas:getWidth() / 2 - COMPONENT_SPRITE_WIDTH / 2 * sx,
            200 - COMPONENT_SPRITE_HEIGHT / 2 * sy,
            0,
            sx,
            sy
        )
        -- draw bounding rectangle
        love.graphics.rectangle(
            "line",
            love.graphics.getWidth() / 2 - _current_sword.canvas:getWidth() / 2 - COMPONENT_SPRITE_WIDTH / 2 * sx,
            200 - COMPONENT_SPRITE_HEIGHT / 2 * sy,
            _current_sword.canvas:getWidth() * sx,
            _current_sword.canvas:getHeight() * sy
        )
    end

    if _debug and _current_sword then
        local counter = 0
        local sx, sy = 8, 8

        for key, component in pairs(_current_sword.components) do
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(key .. ": " .. component.name, 50, 50 + counter * 50)
            counter = counter + 1
        end
    end
end

function swordgen:update(dt)
end

return swordgen
