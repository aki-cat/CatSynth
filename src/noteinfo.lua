local NoteInfo = {}

local C0_OFFSET = 24
local A4_OFFSET = 69
local A4_FREQ = 440

NoteInfo.INFLUENCE = 0.1
NoteInfo.C0 = C0_OFFSET
NoteInfo.A4 = A4_OFFSET

local NOTE_LIST = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" }

local _frequencyCache = {}

local function _calculateFrequency(note)
    return A4_FREQ * 2 ^ ((note - A4_OFFSET) / 12)
end

do -- init
    for note = C0_OFFSET, C0_OFFSET + 88 do
        _frequencyCache[note] = _calculateFrequency(note)
    end
end

function NoteInfo.getNoteFrequency(note)
    if not _frequencyCache[note] then
        _frequencyCache[note] = _calculateFrequency(note)
    end
    return _frequencyCache[note]
end

function NoteInfo.getNoteIndex(note)
    return note - C0_OFFSET
end

function NoteInfo.getNoteFromIndex(noteIndex)
    return noteIndex + C0_OFFSET
end

function NoteInfo.getNoteName(note)
    local noteIndex = NoteInfo.getNoteIndex(note)
    local octave = math.floor(noteIndex / 12)
    local offset = noteIndex % 12 + 1
    return NOTE_LIST[offset] .. octave
end

return NoteInfo
