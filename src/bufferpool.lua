local BufferPool = require "util.class" "BufferPool"
local Consts = require "consts"

local LoveSound = love.sound

function BufferPool:__init(poolSize)
    self._size = poolSize
    self._pointer = 1
    self._buffers = {}
    for i = 1, self._size do
        self._buffers[i] = LoveSound.newSoundData(Consts.BUFFER_SIZE, Consts.SAMPLE_RATE, 16, 1)
    end
end

function BufferPool:request()
    local pointer = self._pointer
    self._pointer = self._pointer % self._size + 1
    return self._buffers[pointer]
end

return BufferPool
