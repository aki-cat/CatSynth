--------------------
-- Utility stuffs --
--------------------
local Log = require "util.log"
local Type = require "util.type"
local Table = require "util.table"
local Func = require "util.func"
local Byte = require "util.byte"
local Math = require "util.math"

_G.func = {}
_G.byte = {}

Table.merge(_G, Log)
Table.merge(_G, Type)
Table.merge(_G.func, Func)
Table.merge(_G.table, Table)
Table.merge(_G.byte, Byte)
Table.merge(_G.math, Math)

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


-- Enhanced print functions that return their input.

[ function [...] -> [...] ] print
[ function [...] -> [...] ] printf


-- Table utility functions appended to global 'table'.

[ function [table]        -> [...]   ] table.unpack
[ function [...]          -> [table] ] table.pack
[ function [table, table] -> [table] ] table.merge

]==]
