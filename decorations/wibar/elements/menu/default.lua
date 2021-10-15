-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-09-29 08:18:44 (Marcel Arpogaus)
-- @Changed: 2021-09-29 20:42:35 (Marcel Arpogaus)
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
local beautiful = require('beautiful')

local hotkeys_popup = require('awful.hotkeys_popup').widget

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    -- This is used later as the default terminal and editor to run.
    config.apps = config.apps or {}
    local gui_editor = config.apps.gui_editor or os.getenv('EDITOR') or 'nano'
    local terminal = config.apps.terminal or 'xterm'

    -- Create a launcher widget and a main menu
    local awesomemenu = {
        {
            'hotkeys',
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end
        },
        {'manual', terminal .. ' -e man awesome'},
        {'edit config', gui_editor .. ' ' .. capi.awesome.conffile},
        {'restart', capi.awesome.restart},
        {'quit', function() capi.awesome.quit() end}
    }

    local menu = awful.menu({
        items = {
            {'awesome', awesomemenu, beautiful.awesome_icon},
            {'open terminal', terminal}
        }
    })

    return menu
end

-- [ return module ] -----------------------------------------------------------
return module
