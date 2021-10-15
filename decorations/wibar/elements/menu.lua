-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : menu.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-09 14:36:47 (Marcel Arpogaus)
-- @Changed: 2021-10-15 09:50:54 (Marcel Arpogaus)
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
local beautiful = require('beautiful')
local menubar = require('menubar')
local wibox = require('wibox')
local gears = require('gears')

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, config)
    local menu_kind = config.kind or 'default'
    local icon
    if type(config.icon) == 'string' then
        icon = menubar.utils.lookup_icon(config.icon)
    else
        icon = beautiful[menu_kind .. 'menu_icon'] or beautiful.awesome_icon
    end

    local menu = require('decorations.wibar.elements.menu.' .. menu_kind).init(
        config)

    return abstract_element.new {
        register_fn = function(_)
            if config.main_menu then s.main_menu = menu end
            local laucher = awful.widget.launcher({image = icon, menu = menu})
            if config.margin then
                local container = gears.table.clone(config.margin)
                table.insert(container, laucher)
                container.widget = wibox.container.margin
                return container
            else
                return laucher
            end
        end,
        unregister_fn = function(_)
            if config.main_menu then s.main_menu = nil end
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
