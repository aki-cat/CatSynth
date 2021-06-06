local Class = require "util.class"

local TimeController = Class "TimeController"

function TimeController:__init(targetFPS)
    self._timer = love.timer
    self._targetDelta = 1 / targetFPS
    self._nextTimeStamp = self._timer.getTime()
    self._measurements = {}
end

function TimeController:startFrame()
    self._nextTimeStamp = self._nextTimeStamp + self._targetDelta
end

function TimeController:endFrame()
    local currentTime = self._timer.getTime()
    if self._nextTimeStamp <= currentTime then
        self._nextTimeStamp = currentTime
        return
    end
    self._timer.sleep(self._nextTimeStamp - currentTime)
end

function TimeController:measure(id, routine, ...)
    local startT = os.clock()
    local result = table.pack(routine(...))
    local elapsedT = os.clock() - startT

    self._measurements[id] = self._measurements[id] or {}
    table.insert(self._measurements[id], elapsedT)

    return table.unpack(result)
end

local REPORT_FORMAT = [[

--- * Routine: %s * ---
    
  + Average elapsed time = %.3f ms
  + Fastest time = %.3f ms
  + Slowest time = %.3f ms

------]]

function TimeController:reportMeasurement(id)
    local total = 0
    local count = #self._measurements[id]
    local lowest = math.huge
    local highest = -math.huge

    for i = 1, count do
        local value = self._measurements[id][i]
        highest = (value > highest) and value or highest
        lowest = (value < lowest) and value or lowest
        total = total + value
    end

    local average = total / count

    return printf(REPORT_FORMAT, id, average * 1000, lowest * 1000, highest * 1000)
end

function TimeController:reportAll()
    local reports = {}

    for id in pairs(self._measurements) do
        reports[id] = self:reportMeasurement(id)
    end

    return reports
end

return TimeController
