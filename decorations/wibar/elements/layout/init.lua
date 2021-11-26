-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 16:17:12 (Marcel Arpogaus)
-- @Changed: 2021-10-18 16:13:25 (Marcel Arpogaus)
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
local awful = require('awful')
local gears = require('gears')

local abstract_element = require('decorations.abstract_element')
local layout_popup = require('decorations.wibar.elements.layout.popup')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, config)
    local use_popup = config.use_popup or false
    local layoutbox, popup
    return abstract_element.new {
        register_fn = function(_)
            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            -- We need one layoutbox per screen.
            layoutbox = awful.widget.layoutbox(s)
            layoutbox:buttons(gears.table.join(
                awful.button({}, 4, function()
                    awful.layout.inc(1)
                end), awful.button({}, 5, function()
                    awful.layout.inc(-1)
                end)))
            if use_popup then
                popup = layout_popup.init()
                popup:bind_to_widget(layoutbox)
            end
            return layoutbox
        end,
        unregister_fn = function(_)
            if use_popup then
                popup:unbind_to_widget(layoutbox)
                popup = nil
            end
            layoutbox:remove()
            layoutbox = nil
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
