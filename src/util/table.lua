local Type = require "util.type"

local Table = {}

local select = _G.select
local pairs = _G.pairs
local type = _G.type
local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable

Table.unpack = Table.unpack or _G.unpack
function Table.pack(...)
    local t = { ... }
    local length = select("#", ...)
    return setmetatable(t, { __len = length })
end

function Table.merge(to, from)
    assert(type(to) == Type.TABLE)

    for key in pairs(from) do
        to[key] = from[key]
    end

    return to
end

function Table.length(t)
    assert(type(t) == Type.TABLE)

    local length = getmetatable(t).__len
    if type(length) == Type.NUMBER then
        return length
    end

    if type(length) == Type.FUNCTION then
        return length(t)
    end

    return #t
end

return Table
