-- Enhancements to string
local Log = {}

local _print = _G.print
local _string = _G.string

function Log.print(...)
    return _print(...) or ...
end

function Log.printf(s, ...)
    return Log.print(_string.format(s, ...))
end

return Log
