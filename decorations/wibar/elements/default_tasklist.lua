-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-21 18:27:36 (Marcel Arpogaus)
-- @Changed: 2021-10-17 17:34:15 (Marcel Arpogaus)
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
local capi = {client = client}

local awful = require('awful')
local gears = require('gears')

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, _)
    return abstract_element.new {
        register_fn = function()
            local tasklist_buttons = gears.table.join(
                awful.button({}, 1, function(c)
                    if c == capi.client.focus then
                        c.minimized = true
                    else
                        c:emit_signal('request::activate', 'tasklist',
                                      {raise = true})
                    end
                end), awful.button({}, 3, function()
                    awful.menu.client_list({theme = {width = 250}})
                end), awful.button({}, 4,
                                   function()
                    awful.client.focus.byidx(1)
                end), awful.button({}, 5,
                                   function()
                    awful.client.focus.byidx(-1)
                end))
            local tasklist = awful.widget.tasklist {
                screen = s,
                filter = awful.widget.tasklist.filter.currenttags,
                buttons = tasklist_buttons
            }
            return tasklist
        end,
        unregister_fn = function() end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
