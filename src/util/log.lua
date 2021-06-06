-- Enhancements to string
local Log = {}

local print = _G.print
local string = _G.string

function Log.print(...)
    return print(...) or ...
end

function Log.printf(s, ...)
    return Log.print(string.format(s, ...))
end

return Log
