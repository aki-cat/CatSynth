local Persistence = require "util.class" "Persistence"
local Encoder = require "util.encoder"
local Type = require "util.type"
local Log = require "util.log"

local FS = love.filesystem

function Persistence:__init(fileName, defaultData)
    self._fileName = string.format("%s.json", fileName)
    if FS.getInfo(self._fileName, "file") then
        Log.printf("File %s exists, loading from disk...", self._fileName)
        self._file = FS.newFile(self._fileName)
    else
        Log.printf("File %s does not exist, creating it...", self._fileName)
        self._file = self:_createFile(self._fileName, defaultData)
        assert(FS.getInfo(self._fileName, "file"))
    end
    self:load()
    assert(Type.type(self._data) == Type.TABLE)
end

function Persistence:set(field, value)
    self._data[field] = value
end

function Persistence:get(field)
    return self._data[field]
end

function Persistence:save()
    self._file:open("w")
    self._file:write(Encoder.serialize(self._data))
    self._file:close()
end

function Persistence:load()
    self._file:open("r")
    self._data = assert(Encoder.deserialize(self._file:read()))
    self._file:close()
end

function Persistence:_createFile(fileName, data)
    local file = FS.newFile(fileName)
    file:open("w")
    file:write(Encoder.serialize(data or {}))
    file:close()
    return file
end

return Persistence
