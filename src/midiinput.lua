local RtMidi = require "luartmidi"

local Class = require "util.class"

local MidiInput = Class "MidiInput"

function MidiInput:__init()
    local dummy = RtMidi.RtMidiIn()

    local API = dummy:getcurrentapi()
    printf("Audio API: %s", RtMidi.RtMidi.getapidisplayname(API))

    local portCount = dummy:getportcount()
    printf("Port count = %s", portCount)

    self.inputs = {}

    for port = 1, portCount do
        self:addInputPort(port)
    end
end

function MidiInput:addInputPort(port)
    if self.inputs[port] then
        return printf("Port '%s' already in use", port)
    end
    self.inputs[port] = RtMidi.RtMidiIn()
    self.inputs[port]:openport(port)
    printf("Opened port %s", self.inputs[port]:getportname(port))
end

function MidiInput:removeInputPort(port)
    if not self.inputs[port] then
        return printf("Port '%s' not in use", port)
    end
    printf("Closing port %s", self.inputs[port]:getportname(port))
    self.inputs[port]:closeport(port)
    self.inputs[port] = nil
end

function MidiInput:getEvents()
    local events = {}
    for port, input in pairs(self.inputs) do
        local dt, midiInfo = input:getmessage()
        if dt then
            table.insert(events, { port = port, delta = dt, info = midiInfo })
            -- local fmt = "[%s] (Port #%d): DELTA: %.6f | MIDI MESSAGE: %s"
            -- printf(fmt, input:getportname(port), port, dt, byte.bytesToHex(midiInfo))
        end
    end
    return events
end

function MidiInput:destroy()
    local closedPorts = {}
    for port, input in pairs(self.inputs) do
        table.insert(closedPorts, port)
    end
    for _, port in pairs(closedPorts) do
        self:removeInputPort(port)
    end
    self.inputs = nil
end

return MidiInput
