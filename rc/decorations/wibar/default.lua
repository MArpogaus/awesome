-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:46:31 (Marcel Arpogaus)
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
local wibox = require('wibox')
local gears = require('gears')

local abstract_decoration = require('rc.decorations.abstract_decoration')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local wibar
    local wibar_elements = {}

    local position = config.position or 'top'
    local layout = 'horizontal'

    local elements = config.elements or {
        {'menu', 'taglist', 'promptbox'}, -- left
        {'default_tasklist'}, -- middle
        {'keyboardlayout', 'systray', 'widgets', 'layout'} -- right
    }

    local decoration = abstract_decoration.new {
        register_fn = function(s)
            if config.screens and
                not gears.table.hasitem(config.screens, s.index) then
                return
            end
            -- Create the wibox
            wibar = awful.wibar({position = position, screen = s})

            -- Add widgets to the wibox
            local wibar_args = {layout = wibox.layout.align[layout]}
            for _, p in ipairs(elements) do
                local widget_container = {layout = wibox.layout.fixed[layout]}
                for d, cfg in utils.value_with_cfg(p) do
                    local w = utils.require_submodule(
                                  'decorations/wibar/elements', d).init(s, cfg)
                                  .register(wibar_elements, wibar)
                    table.insert(widget_container, w)
                end
                table.insert(wibar_args, widget_container)
            end

            -- Add widgets to the wibox
            wibar:setup(wibar_args)

            if s.wibars == nil then s.wibars = {} end
            table.insert(s.wibars, wibar)
        end,
        unregister_fn = function(s)
            for _, d in pairs(wibar_elements) do
                d.unregister(wibar_elements, s)
            end

            wibar.widget:reset()
            wibar:remove()
            wibar = nil
        end,
        update_fn = function(args)
            for _, d in ipairs(wibar_elements) do d.update(args) end
        end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
