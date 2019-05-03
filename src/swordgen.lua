local swordgen = {}

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
local BLADE_SPRITE_WIDTH = 16
local BLADE_SPRITE_HEIGHT = 16
local HILT_SPRITE_WIDTH = 16
local HILT_SPRITE_HEIGHT = 4
local HANDLE_SPRITE_WIDTH = 16
local HANDLE_SPRITE_HEIGHT = 16

local BLADES_SPRITESHEET = love.graphics.newImage("resource/blades.png")

-- TODO: figure out how to anchor. maybe supporting data file/table for each individual sprite? (could do all the same for now)
-- local BLADE_SPRITE_ANCHOR = coordinates(SPRITE_WIDTH / 2, SPRITE_HEIGHT) -- bottom centre
-- local HILT_SPRITE_ANCHOR = coordinates(T)

local HANDLES = {
    {name = "1"},
    {name = "2"}
}

local HILTS = {
    {name = "1"},
    {name = "2"}
}

local BLADES = {
    {name = "1", quad = love.graphics.newQuad()}, -- TODO: quad
    {name = "2"},
    {name = "3"},
    {name = "4"}
}

-- [LOGIC]

function swordgen:generate()
    local new_sword = {
        hilt = choose(unpack(HILTS)),
        blade = choose(unpack(BLADES)),
        handle = choose(unpack(HANDLES))
    }

    return new_sword
end

function swordgen:update(dt)
end

return swordgen
