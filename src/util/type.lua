local Type = {}

local type = _G.type

Type.TABLE = "table"
Type.FUNCTION = "function"
Type.NUMBER = "number"
Type.STRING = "string"
Type.THREAD = "thread"
Type.USERDATA = "userdata"
Type.NULL = "nil"

function Type.type(value)
    local rawType = type(value)
    if rawType ~= Type.TABLE then
        return rawType
    end

    local mt = getmetatable(value)
    if not mt then
        return rawType
    end

    return mt.__type
end

return Type
