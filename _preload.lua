
local p = premake
local api = p.api

p.QNX = "qnx"

api.addAllowed("system", p.QNX)

local sys = p.option.get("os")
if sys and type(sys.allowed) == "table" then
    table.insert(sys.allowed, {"qnx", "QNX"})
end

local cc = p.option.get("cc")
if cc and type(cc.allowed) == "table" then
    table.insert(cc.allowed, {"qcc", "QNX QCC (qcc/QCC)"})
end
