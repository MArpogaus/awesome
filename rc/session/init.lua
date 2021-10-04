-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-01 10:55:49 (Marcel Arpogaus)
-- @Changed: 2021-09-30 08:04:51 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local capi = {awesome = awesome}

local awful = require('awful')

-- helper function
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local desktop_entry_execution = function(environment)
    environment = environment or 'awesome'
    local args
    if environment then args = string.format('-e %s', environment) end
    local command = string.format('command -v dex && dex -a %s', args)
    awful.spawn.with_shell(command)
end

-- [ module functions ] --------------------------------------------------------
module.init = function(config, callback)
    local xrdb_key = 'awesome.started'
    local environment = config.environment
    local autostart = config.autostart or {}
    local startup_dalay = config.startup_delay or 0.2
    if not capi.awesome.xrdb_get_value('', xrdb_key) then
        desktop_entry_execution(environment)
        for _, p in ipairs(autostart) do awful.spawn.with_shell(p) end
        utils.xrdb_set_value(xrdb_key, 'true')
        awful.spawn.easy_async_with_shell(
            string.format('sleep %.1f', startup_dalay),
            function() capi.awesome.restart() end)
    else
        callback()
    end
end

-- [ return module ] -----------------------------------------------------------
return module
