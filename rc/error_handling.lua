--------------------------------------------------------------------------------
-- @File:   error_handling.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   marcel
-- @Last Modified time: 2019-12-03 15:05:45
-- @Changes: 
-- 		- newly written
-- 		- ...
--------------------------------------------------------------------------------

-- [ module imports ] ----------------------------------------------------------
-- Notification library
local naughty = require("naughty")

-- [ sequential ] --------------------------------------------------------------

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                                  title = "Oops, there were errors during startup!",
                                  text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                                      title = "Oops, an error happened!",
                                      text = tostring(err) })
        in_error = false
    end)
end
