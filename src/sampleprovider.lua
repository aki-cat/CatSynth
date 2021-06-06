local Consts = require "consts"
local BufferPool = require "bufferpool"
local NoteInfo = require "noteinfo"
local Soundwave = require "soundwave"

local LoveSound = love.sound

local SampleProvider = require "util.class" "SampleProvider"

function SampleProvider:__init()
    self._lastTimeStamp = love.timer.getTime()
    self._bufferPool = BufferPool:new(64)
end

function SampleProvider:generateBuffers(currentTime, playingNotes)
    local bufferCount = math.ceil((currentTime - self._lastTimeStamp) * Consts.BUFFERS_PER_SECOND)
    local prevTime = self._lastTimeStamp
    self._lastTimeStamp = self._lastTimeStamp + bufferCount * Consts.BUFFER_DURATION

    local soundDataList = {}

    for bufferIndex = 0, bufferCount - 1 do
        soundDataList[bufferIndex + 1] = self:_generateBuffer(prevTime, bufferIndex, playingNotes)
    end

    return soundDataList
end

function SampleProvider:_generateBuffer(prevTime, bufferIndex, playingNotes)
    local soundData = self._bufferPool:request()

    for sampleOffset = 0, Consts.BUFFER_SIZE - 1 do
        local sampleIndex = bufferIndex * Consts.BUFFER_SIZE + sampleOffset
        local tAbsolute = prevTime + sampleIndex * Consts.SECONDS_PER_SAMPLE
        local data = 0

        for _, noteWave in pairs(playingNotes) do
            data = data + noteWave:calculateWavePoint(tAbsolute) * NoteInfo.INFLUENCE
        end

        soundData:setSample(sampleOffset, data)
    end

    return soundData
end

function SampleProvider:getLastTimeStamp()
    return self._lastTimeStamp
end

return SampleProvider
