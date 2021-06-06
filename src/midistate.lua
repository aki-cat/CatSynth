local Queue = require "util.queue"
local NoteInfo = require "noteinfo"
local MidiSignals = require "midisignals"
local NoteWave = require "notewave"
local SampleProvider = require "sampleprovider"

local MidiState = require "util.class" "MidiState"

function MidiState:__init()
    self._sampleProvider = SampleProvider:new()
    self._notesByIndex = self:_createNoteArray()
    self._noteWaves = {}
    self._playingCount = 0
end

function MidiState:_createNoteArray()
    local noteArray = {}

    -- 88 keys
    for noteIndex = 1, 88 do
        noteArray[noteIndex] = false
    end

    return noteArray
end

function MidiState:playNote(note, speed, time)
    local noteIndex = NoteInfo.getNoteIndex(note)
    if self._notesByIndex[noteIndex] then
        printf("WARNING: Mismatched MIDI PLAY_NOTE for %s!", NoteInfo.getNoteName(note))
        return
    end
    self._notesByIndex[noteIndex] = true
    self._noteWaves[note] = NoteWave:new(note, speed, time)
    self._playingCount = self._playingCount + 1
end

function MidiState:stopNote(note, speed, time)
    local noteIndex = NoteInfo.getNoteIndex(note)
    if not self._notesByIndex[noteIndex] then
        printf("WARNING: Mismatched MIDI STOP_NOTE for %s!", NoteInfo.getNoteName(note))
        return
    end
    self._notesByIndex[noteIndex] = false
    self._noteWaves[note]:setStopTime(time)
    self._playingCount = self._playingCount - 1
end

function MidiState:isPlaying()
    return self._playingCount > 0
end

function MidiState:getPlayingNotes()
    local noteWaves = {}
    local i = 1

    for noteIndex, noteState in ipairs(self._notesByIndex) do
        local note = NoteInfo.getNoteFromIndex(noteIndex)
        local noteWave = self._noteWaves[note]
        if noteWave then
            noteWaves[i] = noteWave
            i = i + 1
        end
    end

    return noteWaves
end

function MidiState:generateSamples(timeStamp)
    return self._sampleProvider:generateBuffers(timeStamp, self:getPlayingNotes())
end

function MidiState:cleanMuteNotes()
    local lastTimeStamp = self._sampleProvider:getLastTimeStamp()

    local tbd = {}

    for note, noteWave in pairs(self._noteWaves) do
        if noteWave:isDead(lastTimeStamp) then
            tbd[note] = true
        end
    end

    for note in pairs(tbd) do
        self._noteWaves[note] = nil
    end
end

return MidiState
