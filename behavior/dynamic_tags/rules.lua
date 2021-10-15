-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rules.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 17:41:25 (Marcel Arpogaus)
-- @Changed: 2021-10-13 10:40:52 (Marcel Arpogaus)
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

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(dynamic_tags, _, _)
    -- workaround for now
    function awful.rules.high_priority_properties.dynamic_tag(c, value, props)
        local tag = awful.tag.find_by_name(c.screen, value.name)
        if not tag then
            awful.rules.high_priority_properties.new_tag(c, value, props)
        end
        awful.rules.high_priority_properties.tag(c, value.name, props)
    end

    local rules = {}
    for tag, def in pairs(dynamic_tags) do
        local new_tag = gears.table.clone(def)
        local rule = new_tag.rule
        new_tag.rule = nil
        new_tag.name = tag
        new_tag.volatile = new_tag.volatile or true
        if not rule.properties then rule.properties = {} end
        rule.properties.dynamic_tag = new_tag
        rule.properties.switchtotag = rule.properties.switchtotag or true
        rules[tag] = rule
    end

    return rules
end

-- [ return module ] -----------------------------------------------------------
return module
