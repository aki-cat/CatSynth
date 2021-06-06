local Json = require "ext.dkjson.dkjson"
local Type = require "util.type"

-- Use library
local Encoder = {}

local function _generateKeyOrder(t)
    local function getAllKeys(from, out)
        out = out or {}
        for key, value in pairs(from) do
            if Type.type(key) == Type.STRING then
                table.insert(out, key)
            end
            if Type.type(value) == Type.TABLE then
                getAllKeys(value, out)
            end
        end
        return out
    end

    local orderedKeys = getAllKeys(t, {})

    table.sort(orderedKeys)
    return orderedKeys
end

-- data -> bytes
function Encoder.serialize(data)
    local orderedKeys = _generateKeyOrder(data)
    return Json.encode(data, { indent = true, keyorder = orderedKeys })
end

-- bytes -> data
function Encoder.deserialize(bytes)
    return setmetatable(Json.decode(bytes), nil)
end

return Encoder
