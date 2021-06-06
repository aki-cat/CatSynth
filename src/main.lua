require "util"

local Persistence = require "util.persistence"
local Consts = require "consts"

local TimeController = require "timecontroller"
local MidiSignals = require "midisignals"
local MidiInput = require "midiinput"
local MidiState = require "midistate"

-- user config
local _userConfig

-- local instances
local _timeController
local _midiInput
local _midiState
local _streamingAudio

-- local rendering values
local _waveData = {}
local _waveHeight = 127
local _waveDepth = 480

-- local debugging keyboard keys for playing notes
local _keyboardKeys = { q = 0, w = 2, e = 4, r = 5, t = 7, y = 9, u = 11, i = 12, o = 14, p = 16 }

-- local routines

local function _getMidiEvents()
    local midiEvents = _midiInput:getEvents()
    local currentTime = love.timer.getTime()

    for _, midiEvent in ipairs(midiEvents) do

        local status, note, speed = table.unpack(midiEvent.info)
        local noteStatus = math.floor(status / 16)

        if noteStatus == MidiSignals.NOTE_ON then
            _midiState:playNote(note, speed, currentTime)
        elseif noteStatus == MidiSignals.NOTE_OFF then
            _midiState:stopNote(note, speed, currentTime)
        end
    end
end

local function _supplyBuffersToStream()
    local currentTime = love.timer.getTime()

    local nextBuffers = _midiState:generateSamples(currentTime)

    if _streamingAudio:getFreeBufferCount() > 0 then
        _waveData = {}

        for _, soundData in ipairs(nextBuffers) do
            -- Length is in BYTES, better let LÖVE calculate it automatically
            _streamingAudio:queue(soundData)
            if #_waveData < 4 then
                table.insert(_waveData, soundData)
            end
        end

        if not _streamingAudio:isPlaying() then
            _streamingAudio:play()
        end
    end
end

-- local rendering routines

local function _renderText(graphics)
    graphics.printf(string.format("FPS %.2f", love.timer.getFPS()), 12, 12, 256)
    graphics.printf(string.format("FREE BUFFER COUNT: %d", _streamingAudio:getFreeBufferCount()),
                    12, 36, 256)
end

local function _renderWave(graphics)
    local windowWidth, windowHeight = love.window.getMode()
    local y = windowHeight / 2

    local left = 0
    local right = windowWidth
    local waveWidth = right - left
    local lineWidth = math.ceil(waveWidth / _waveDepth)
    graphics.setLineWidth(2)
    local points = {}
    local sampleCount = #_waveData * Consts.BUFFER_SIZE
    for bufferIndex, soundData in ipairs(_waveData) do
        local sampleOffset = (bufferIndex - 1) * Consts.BUFFER_SIZE
        for i = 0, Consts.BUFFER_SIZE - 1 do
            local x = waveWidth * (sampleOffset + i) / sampleCount
            local sampleValue = soundData:getSample(i)
            table.insert(points, x + left)
            table.insert(points, y + sampleValue * _waveHeight)
            x = x + 1
        end
    end

    return #points > 1 and graphics.line(points)
end

local function _render(graphics)
    graphics.clear(0.2, 0.2, 0.2)
    graphics.setColor(1, 1, 1)
    _renderWave(graphics)
    _renderText(graphics)
end

-- main love callbacks

function love.load()
    -- initialization
    _userConfig = Persistence:new("userconfig")

    _timeController = TimeController:new(Consts.FPS)
    _midiInput = MidiInput:new()
    _midiState = MidiState:new()
    _streamingAudio = love.audio.newQueueableSource(Consts.SAMPLE_RATE, 16, 1, 64)
end

local _count = 0
function love.update(dt)
    _timeController:startFrame()
    _count = _count + 1
    if _count > Consts.FPS then
        _count = 0
        collectgarbage()
    end
    _getMidiEvents()
    _supplyBuffersToStream()
    _midiState:cleanMuteNotes()
end

function love.draw()
    _render(love.graphics)
    _timeController:endFrame()
end

function love.keypressed(key)
    if key == "f8" then
        love.event.quit()
    end

    if key == "f2" then
        _timeController:reportAll()
    end

    if key == "f5" then
        love.quit(true)
        love.load()
    end

    if _keyboardKeys[key] then
        _midiState:playNote(60 + _keyboardKeys[key], 0x40, love.timer.getTime())
    end
end

function love.keyreleased(key)
    if _keyboardKeys[key] then
        _midiState:stopNote(60 + _keyboardKeys[key], 0x40, love.timer.getTime())
    end
end

function love.quit(confirm)

    _timeController:reportAll()
    _userConfig:save()
    _midiInput:destroy()
    collectgarbage()

    return confirm
end
