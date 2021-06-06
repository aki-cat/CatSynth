require "util"

local RtMidiLib = require "luartmidi"

function love.load()
    -- initialization
    table.merge(_G, RtMidiLib)
end

function love.update(_)
    -- banana
end

function love.keypressed(key)
    -- ayyy
    if key == "f8" then
        love.event.quit()
    end
end
