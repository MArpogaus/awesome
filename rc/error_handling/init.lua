-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:52:28 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {awesome = awesome}

-- Notification library
local naughty = require('naughty')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ sequential code ] ---------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if capi.awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = 'Oops, there were errors during startup!',
            text = capi.awesome.startup_errors
        }
    )
end

-- [ module functions ] --------------------------------------------------------
module.init = function()
    -- Handle runtime errors after startup
    local in_error = false
    capi.awesome.connect_signal(
        'debug::error', function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true
            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = 'Oops, an error happened!',
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- [ return module ] -----------------------------------------------------------
return module
