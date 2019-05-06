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
local HILT_SPRITE_WIDTH = 16
local HILT_SPRITE_HEIGHT = 16

local HANDLE_SPRITE_HEIGHT = 16
local HANDLE_SPRITE_WIDTH = 16

local BLADE_SPRITE_WIDTH = 16
local BLADE_SPRITE_HEIGHT = 24

local BLADES_SPRITESHEET = love.graphics.newImage("resource/blades.png")
local HILTS_SPRITESHEET = love.graphics.newImage("resource/hilts.png")
local HANDLES_SPRITESHEET = love.graphics.newImage("resource/handles.png")

local HILTS = nil
local HANDLES = nil
local BLADES = nil

-- [LOGIC]

function create_blade_quad(x, y)
    return create_component_quad(
        x * BLADE_SPRITE_WIDTH,
        y * BLADE_SPRITE_HEIGHT,
        BLADE_SPRITE_WIDTH,
        BLADE_SPRITE_HEIGHT,
        BLADES_SPRITESHEET
    )
end

function create_hilt_quad(x, y)
    return create_component_quad(
        x * HILT_SPRITE_WIDTH,
        y * HILT_SPRITE_HEIGHT,
        HILT_SPRITE_WIDTH,
        HILT_SPRITE_HEIGHT,
        HILTS_SPRITESHEET
    )
end

function create_handle_quad(x, y)
    return create_component_quad(
        x * HANDLE_SPRITE_WIDTH,
        y * HANDLE_SPRITE_HEIGHT,
        HANDLE_SPRITE_WIDTH,
        HANDLE_SPRITE_HEIGHT,
        HANDLES_SPRITESHEET
    )
end

function create_component_quad(x, y, width, height, sprite_sheet)
    return love.graphics.newQuad(x, y, width, height, sprite_sheet:getWidth(), sprite_sheet:getHeight())
end

function load_components()
    HILTS = require("resource/hilts")
    HANDLES = require("resource/handles")
    BLADES = require("resource/blades")
end

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
    local canvas = love.graphics.newCanvas(16, 48)
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1, 1, 1)
    -- draw handle at the bottom
    love.graphics.draw(HANDLES_SPRITESHEET, sword.components.handle.quad, 0, canvas:getHeight() - HANDLE_SPRITE_HEIGHT)

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
        canvas:getHeight() - HANDLE_SPRITE_HEIGHT + hilt_offset.y
    )

    -- Draw blade (bottom pivot) above hilt (top pivot)
    local blade_offset =
        coordinates(
        sword.components.hilt.fixtures.blade.x - sword.components.blade.fixtures.hilt.x,
        sword.components.hilt.fixtures.blade.y - sword.components.blade.fixtures.hilt.y
    )
    love.graphics.draw(
        BLADES_SPRITESHEET,
        sword.components.blade.quad,
        blade_offset.x,
        canvas:getHeight() - HANDLE_SPRITE_HEIGHT + hilt_offset.y + blade_offset.y
    )

    love.graphics.setCanvas()

    sword.canvas = canvas
    return sword
end

function swordgen:generate()
    local new_sword = self:create_new()
    new_sword = self:combine(new_sword)

    -- TODO: Gem fixtures to randomly insert? (1x1, 2x2?)
    -- TODO: Use a pixel shader to allow palette swapping components before drawing on canvas!!!!!!!! (bronze, steel, black, etc??)
    -- TODO: add a special effect of some kinda?
    -- TODO: different stats?
    -- TODO: name generator?
    -- TODO: Place one in the world of a game and wield it!!

    _current_sword = new_sword
end

function swordgen:draw()
    if _current_sword.canvas then
        local sx, sy = 12, 12
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            _current_sword.canvas,
            love.graphics.getWidth() / 2 - _current_sword.canvas:getWidth() / 2 * sx,
            love.graphics.getHeight() / 2 - _current_sword.canvas:getHeight() / 2 * sy,
            0,
            sx,
            sy
        )

        love.graphics.setColor(0.5, 0.5, 0.5)
        -- draw bounding rectangle
        love.graphics.rectangle(
            "line",
            love.graphics.getWidth() / 2 - _current_sword.canvas:getWidth() / 2 * sx,
            love.graphics.getHeight() / 2 - _current_sword.canvas:getHeight() / 2 * sy,
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

load_components()

return swordgen
