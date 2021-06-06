local Type = require "util.type"
local Func = require "util.func"
local Log = require "util.log"

local _error = error
local _string = string

-- How original, another self-made class system.
local Class = {}

-- Forward declaration
local _createClass
local _instantiate

function _createClass(_, name)
    -- Log.printf("Class '%s' registered!", name)
    return setmetatable({ new = _instantiate }, { __class = name })
end

function _instantiate(class, ...)
    local object = setmetatable({}, { __class = class, __index = class })
    local constructor = class.__init
    if Type.type(constructor) == Type.FUNCTION then
        constructor(object, ...)
    end
    return object
end

return setmetatable(Class, { __newindex = Func.noop, __call = _createClass })
