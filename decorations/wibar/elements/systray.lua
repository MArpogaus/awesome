-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : systray.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-09 13:45:01 (Marcel Arpogaus)
-- @Changed: 2021-10-08 08:39:52 (Marcel Arpogaus)
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

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, _)
    return abstract_element.new {
        register_fn = function(w)
            s.systray = wibox.widget.systray()

            s.systray_set_screen = function()
                if s.systray then s.systray:set_screen(s) end
            end
            w:connect_signal('mouse::enter', s.systray_set_screen)
            return s.systray
        end,
        unregister_fn = function(w)
            w:disconnect_signal('mouse::enter', s.systray_set_screen)
            s.systray = nil
            s.systray_set_screen = nil
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
