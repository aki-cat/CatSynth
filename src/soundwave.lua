local Table = require "util.table"

local Soundwave = {}

local _math = _G.math

local TAU = 2 * _math.pi

-- x T => [-1, 1]
function Soundwave.sin(x)
    return _math.sin(x * TAU)
end

-- x T => [-1, 1]
function Soundwave.triangle(x)
    return 4 * math.abs(math.fmod((x - 0.25), 0.5)) - 1
end

-- x T => [-1, 1]
function Soundwave.saw(x)
    return math.fmod(x, 2) - 1
end

-- x T => [-1, 1]
function Soundwave.square(x)
    return (-1) ^ math.floor(2 * x)
end

-- x T => [-1, 1]
function Soundwave.compound(x, curves)
    assert(type(curves) == TABLE)
    local y = 0
    local curveCount = #curves
    local influence = 1 / curveCount
    for i = 1, curveCount do
        y = y + curves[i](x) * influence
    end
    return y
end

return Soundwave
