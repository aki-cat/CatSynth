local Type = {}

Type.TABLE = "table"
Type.FUNCTION = "function"
Type.NUMBER = "number"
Type.STRING = "string"
Type.THREAD = "thread"
Type.USERDATA = "userdata"
Type.NULL = "nil"

Type.type = _G.type

return Type
