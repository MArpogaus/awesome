-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-01 10:55:49 (Marcel Arpogaus)
-- @Changed: 2021-10-18 17:17:24 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- Copyright (C) 2021 Marcel Arpogaus
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
    startup_delay = 0.2,
    disable_dex = false
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
    self.config = utils.deep_merge(self.defaults, cfg or {}, 0)
    local xrdb_key = 'awesome.started'
    if not self.config.disable_autostart and
        not capi.awesome.xrdb_get_value('', xrdb_key) then
        if not self.config.disable_dex then
            desktop_entry_execution(self.config.environment)
        end
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
