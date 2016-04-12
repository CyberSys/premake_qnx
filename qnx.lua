
include("_preload.lua")
include("toolset.lua")

premake.modules.qnx = {}
local m = premake.modules.qnx
m._VERSION = "0.0.1"

filter { "configurations:qnx" }
    system("qnx")
    toolset("qnx")

return m
