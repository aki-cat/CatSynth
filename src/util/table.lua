local Type = require "util.type"

local Table = {}

local _assert = _G.assert
local _type = _G.type
local _select = _G.select
local _pairs = _G.pairs
local _table = _G.table
local _string = _G.string
local _rawset = _G.rawset
local _getmetatable = _G.getmetatable
local _setmetatable = _G.setmetatable

-- Forward declaration of local helper functions
local _recursiveCopy

Table.unpack = Table.unpack or _G.unpack
function Table.pack(...)
    local t = { ... }
    t.__length = _select("#", ...)
    return t
end

function Table.merge(to, from)
    _assert(_type(to) == Type.TABLE and _type(from) == Type.TABLE, "Can only merge tables")

    for key in _pairs(from) do
        to[key] = from[key]
    end

    return to
end

function Table.copy(t)
    return _recursiveCopy(t, {})
end

-- Local helper functions

function _recursiveCopy(t, refCache)
    _assert(not refCache[t], "Cannot copy table with cyclic reference.")
    _assert(not _getmetatable(t), "Cannot copy table with metatable.")

    local out = {}

    for key, value in _pairs(t) do
        _assert(_type(key) ~= Type.TABLE, "Cannot copy tables with a table as key.")

        if _type(value) == Type.TABLE then
            _rawset(out, key, _recursiveCopy(value, refCache))
        else
            _rawset(out, key, value)
        end
    end

    return out
end

return Table
