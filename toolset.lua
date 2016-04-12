
include("_preload.lua")

local qnx_target = "QNX_TARGET"
if os.is("windows") then
    qnx_target = "%"..qnx_target.."%"
elseif os.is("linux") then
    qnx_target = "$"..qnx_target
else
    qnx_target = "$"..qnx_target
end

local p = premake

p.tools.qnx = {}
local qnx = p.tools.qnx
local gcc = p.tools.gcc
local config = p.config

--
-- Build a list of flags for the C preprocessor corresponding to the
-- settings in a particular project configuration.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C preprocessor flags.
--
function qnx.getcppflags(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getcppflags(cfg)
    return flags
end

--
-- Build a list of C compiler flags corresponding to the settings in
-- a particular project configuration. These flags are exclusive
-- of the C++ compiler flags, there is no overlap.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C compiler flags.
--
function qnx.getcflags(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getcflags(cfg)
    return flags
end

--
-- Build a list of C++ compiler flags corresponding to the settings
-- in a particular project configuration. These flags are exclusive
-- of the C compiler flags, there is no overlap.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C++ compiler flags.
--
function qnx.getcxxflags(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getcxxflags(cfg)
    --table.insert(flags, "-nostdinc++")
    --table.insert(flags, "-nostdinc")
    return flags
end

--
-- Returns a list of defined preprocessor symbols, decorated for
-- the compiler command line.
--
-- @param defines
--    An array of preprocessor symbols to define; as an array of
--    string values.
-- @return
--    An array of symbols with the appropriate flag decorations.
--
function qnx.getdefines(defines)
    -- Just pass through to GCC for now
    local flags = gcc.getdefines(defines)
    table.insert(flags, "-D__QNX__")
    table.insert(flags, "-D__QNXNTO__")
    return flags
end

function qnx.getundefines(undefines)
    -- Just pass through to GCC for now
    local flags = gcc.getundefines(undefines)
    return flags
end

--
-- Returns a list of forced include files, decorated for the compiler
-- command line.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of force include files with the appropriate flags.
--
function qnx.getforceincludes(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getforceincludes(cfg)
    return flags
end

--
-- Returns a list of include file search directories, decorated for
-- the compiler command line.
--
-- @param cfg
--    The project configuration.
-- @param dirs
--    An array of include file search directories; as an array of
--    string values.
-- @return
--    An array of symbols with the appropriate flag decorations.
--
function qnx.getincludedirs(cfg, dirs, sysdirs)
    -- Just pass through to GCC for now
    local flags = gcc.getincludedirs(cfg, dirs, sysdirs)
    --table.insert(flags, '-I' .. p.quoted(qnx_target .. "/usr/include/cpp/c"))
    --table.insert(flags, '-I' .. p.quoted(qnx_target .. "/usr/include/cpp"))
    --table.insert(flags, '-I' .. p.quoted(qnx_target .. "/usr/include"))
    return flags
end

function qnx.getldflags(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getldflags(cfg)
    return flags
end

qnx.libraryDirectories =
{
    architecture =
    {
        x86 = "-L" .. p.quoted(qnx_target .. "/x86/lib"),
    }
}

--
-- Build a list of additional library directories for a particular
-- project configuration, decorated for the tool command line.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of decorated additional library directories.
--
function qnx.getLibraryDirectories(cfg)
    local flags = config.mapFlags(cfg, qnx.libraryDirectories)

    -- Scan the list of linked libraries. If any are referenced with
    -- paths, add those to the list of library search paths. The call
    -- config.getlinks() all includes cfg.libdirs.
    for _, dir in ipairs(config.getlinks(cfg, "system", "directory")) do
        table.insert(flags, '-L' .. p.quoted(dir))
    end

    if cfg.flags.RelativeLinks then
        for _, dir in ipairs(config.getlinks(cfg, "siblings", "directory")) do
            local libFlag = "-L" .. p.project.getrelative(cfg.project, dir)
            if not table.contains(flags, libFlag) then
                table.insert(flags, libFlag)
            end
        end
    end

    for _, dir in ipairs(cfg.syslibdirs) do
        table.insert(flags, '-L' .. p.quoted(dir))
    end

    return flags
end

function qnx.getlinksonly(cfg, systemonly)
    -- Just pass through to GCC for now
    local flags = gcc.getlinksonly(cfg, systemonly)
    return flags
end

--
-- Build a list of libraries to be linked for a particular project
-- configuration, decorated for the linker command line.
--
-- @param cfg
--    The project configuration.
-- @param systemOnly
--    Boolean flag indicating whether to link only system libraries,
--    or system libraries and sibling projects as well.
-- @return
--    A list of libraries to link, decorated for the linker.
--
function qnx.getlinks(cfg, systemOnly)
    -- Just pass through to GCC for now
    local flags = gcc.getlinks(cfg, systemOnly)
    return flags
end

--
-- Return a list of makefile-specific configuration rules. This will
-- be going away when I get a chance to overhaul these adapters.
--
-- @param cfg
--    The project configuration.
-- @return
--    A list of additional makefile rules.
--
function qnx.getmakesettings(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getmakesettings(cfg)
    return flags
end

function qnx.getwarnings(cfg)
    -- Just pass through to GCC for now
    local flags = gcc.getwarnings(cfg)
    return flags
end

-- TODO: Support QNX qcc/QCC compilers.
qnx.tools =
{
    cc = "ntox86-gcc",
    cxx = "ntox86-g++",
    ar = "ntox86-ar",
}

function qnx.gettoolname(cfg, tool)
    return qnx.tools[tool]
end
