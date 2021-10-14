-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-01 10:55:49 (Marcel Arpogaus)
-- @Changed: 2021-10-09 11:53:20 (Marcel Arpogaus)
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
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    environment = 'awesome',
    autostart = {},
    startup_delay = 0.2
}

-- [ local functions ] ---------------------------------------------------------
local desktop_entry_execution = function(environment)
    local args
    if environment then args = string.format('-e %s', environment) end
    local command = string.format('command -v dex && dex -a %s', args)
    awful.spawn.with_shell(command)
end

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg, callback)
    self.config = utils.deep_merge(self.defaults, cfg or {}, 1)
    local xrdb_key = 'awesome.started'
    if not capi.awesome.xrdb_get_value('', xrdb_key) then
        desktop_entry_execution(self.config.environment)
        for _, p in ipairs(self.config.autostart) do
            awful.spawn.with_shell(p)
        end
        utils.xrdb_set_value(xrdb_key, 'true')
        awful.spawn.easy_async_with_shell(
            string.format('sleep %.1f', self.config.startup_delay),
            function() capi.awesome.restart() end)
    else
        callback()
    end
end

-- [ return module ] -----------------------------------------------------------
return module
