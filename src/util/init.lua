--------------------
-- Utility stuffs --
--------------------
local Log = require "util.log"
local Type = require "util.type"
local Table = require "util.table"

Table.merge(_G, Log)
Table.merge(_G, Type)
Table.merge(_G.table, Table)

print("Lua enhancement utility initialized!")

--[==[ --

-- Global values for type names to avoid literals.

[string] TABLE
[string] FUNCTION
[string] NUMBER
[string] STRING
[string] THREAD
[string] USERDATA
[string] NULL


-- Type getter that returns one of the values above or custom types via metatable '__type' field.

[ function [any] -> [string] ] type


-- Enhanced print functions that return their input.

[ function [...] -> [...] ] print
[ function [...] -> [...] ] printf


-- Table utility functions appended to global 'table'.

[ function [table]        -> [...]   ] table.unpack
[ function [...]          -> [table] ] table.pack
[ function [table, table] -> [table] ] table.merge

-- This one gets the length using table's metatable '__len' field. Defaults to # operator.
[ function [table]        -> [number]] table.length

]==]
