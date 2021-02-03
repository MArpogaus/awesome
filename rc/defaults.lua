-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : defaults.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 15:12:05 (Marcel Arpogaus)
-- @Changed: 2021-02-03 17:50:44 (Marcel Arpogaus)
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
local wibox = require('wibox')
local awful = require('awful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- keys
module.modkey = 'Mod4'
module.altkey = 'Mod1'

-- applications
module.browser = 'firefox'
module.filemanager = 'thunar'
module.gui_editor = 'nano'
module.key_bindings = {'default'}
module.bind_numbers_to_tags = true
module.lock_command = 'light-locker-command -l'
module.terminal = 'xterm'

-- layouts
module.default_layout = 0
module.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- behavior
module.behavior = {'default'}

module.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- appearance
module.auto_dpi = true
module.tasklist = 'default'
module.mainmenu = true

-- widgets
module.arc_widgets = {'cpu', 'mem', 'fs', 'vol'}
module.desktop_widgets_visible = true
module.wibar_widgets = {wibox.widget.textclock()}
module.widgets_arg = {}

-- [ return module ] -----------------------------------------------------------
return module
