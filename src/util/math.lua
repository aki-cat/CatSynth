local Math = {}

local _math = _G.math

function Math.clamp(value, min, max)
    return _math.min(_math.max(value, min), max)
end

function Math.interpolate(min, max, percentage)
    return min + (percentage * (max - min))
end

function Math.round(x)
    return _math.floor(x + 0.5)
end

return Math
