local Consts = require "consts"
local NoteInfo = require "noteinfo"
local Envelope = require "envelope"
local Soundwave = require "soundwave"

local NoteWave = require "util.class" "NoteWave"

-- envelope is optional?
function NoteWave:__init(note, speed, startTime)
    self._note = note
    self._noteStart = startTime
    self._env = Envelope:new({ intensity = 0.25 + 2 * speed / 0x80 })
end

function NoteWave:setStopTime(stopTime)
    self._env:setStopTime(stopTime - self._noteStart)
end

function NoteWave:hasStopTime()
    return self._env:hasStopTime()
end

function NoteWave:setEnvelope(envelope)
    self._env = envelope
end

function NoteWave:isDead(tPrevious)
    return self._env:isDead(tPrevious - self._noteStart)
end

function NoteWave:calculateWavePoint(tAbsolute)
    local frequency = NoteInfo.getNoteFrequency(self._note) + 10e-7 * math.sin(tAbsolute * 32)
    local x = tAbsolute * frequency
    local wavePoint = Soundwave.triangle(x) * 0.3 + Soundwave.sin(x) * 0.7
    local envelope = self._env:calculate(tAbsolute - self._noteStart)
    return wavePoint * envelope
end

return NoteWave
