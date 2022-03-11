-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-09-29 08:18:44 (Marcel Arpogaus)
-- @Changed: 2022-03-11 16:14:25 (Marcel Arpogaus)
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
-- grab environment
local capi = {awesome = awesome}

-- Standard awesome library
local awful = require('awful')
local menubar = require('menubar')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local lock_command = config.lock_command or 'light-locker-command -l'
    local exit_command = config.exit_command or
                             'loginctl terminate-session self'
    local suspend_command = config.suspend_command or 'systemctl suspend'
    local hibernate_command = config.hibernate_command or 'systemctl hibernate'
    local reboot_command = config.reboot_command or 'systemctl reboot'
    local poweroff_command = config.poweroff_command or 'poweroff'

    local exitmenu = {
        {'log out', exit_command, menubar.utils.lookup_icon('system-log-out')},
        {
            'lock screen',
            lock_command,
            menubar.utils.lookup_icon('system-lock-screen')
        },
        {
            'suspend',
            suspend_command,
            menubar.utils.lookup_icon('system-suspend')
        },
        {
            'hibernate',
            hibernate_command,
            menubar.utils.lookup_icon('system-suspend-hibernate')
        },
        {'reboot', reboot_command, menubar.utils.lookup_icon('system-reboot')},
        {
            'shutdown',
            poweroff_command,
            menubar.utils.lookup_icon('system-shutdown')
        }
    }
    local menu = awful.menu({items = exitmenu})
    return menu
end

-- [ return module ] -----------------------------------------------------------
return module
