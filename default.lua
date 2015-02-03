if not _REQUIREDNAME then
    error('Don\'t load directly, use require "libluafs"', 2)
end

-- Get libname.
local libname  = os.getenv "LUA_SOPATH"
if libname then
    if not string.find(libname, '/$') then
        libname = libname .. "/"
    end
else
    libname = "/usr/lib/lua/5.0/"
end

libname = libname .. _REQUIREDNAME .. ".so"

local funcname = "luaopen_" .. _REQUIREDNAME
local f, err = loadlib(libname, funcname)

if not f then
    error("loadlib('" .. libname .. "', '" .. funcname .. "') failed: " .. err, 2)
end

local function ret(s, ...)
    if s then
        return unpack(arg)
    end
    error(_REQUIREDNAME .. "'s " .. funcname .. " failed: " .. arg[1], 3)
end
return ret(pcall(f))
