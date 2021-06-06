local Class = require "util.class"
local Log = require "util.log"

local Queue = Class "Queue"

local function _assert(condition, msg)
    if not condition then
        return io.stderr:write(msg .. "\n")
    end
end

function Queue:__init(maxSize)
    _assert(maxSize > 1, "Queue max size must be at least 2")
    self._maxSize = maxSize
    self._size = 0
    self._head = 1
    self._tail = 1
    self._queue = {}
    for i = 1, self._maxSize do
        self._queue[i] = nil
    end
end

function Queue:push(value)
    _assert(self._size < self._maxSize, "Queue overflow.")
    self._queue[self._tail] = value
    self._tail = self._tail % self._maxSize + 1
    self._size = self._size + 1
end

function Queue:pop()
    _assert(self._size > 0, "Cannot pop empty queue.")
    local value = self._queue[self._head]
    self._head = self._head % self._maxSize + 1
    self._size = self._size - 1
    return value
end

function Queue:peek()
    return self._size > 0 and self._queue[self._head] or nil
end

function Queue:getSize()
    return self._size
end

function Queue:isEmpty()
    return self._size <= 0
end

return Queue
