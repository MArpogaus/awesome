-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-10-06 12:59:12 (Marcel Arpogaus)
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
local wibars = setmetatable({}, {__mode = 'k'}) -- make keys weak
local wibars_visible = true

-- [ module functions ] --------------------------------------------------------
module.init = function(config)

    local position = config.position or 'top'
    local layout = 'horizontal'
    wibars_visible = wibars_visible or config.visible

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

            -- check if wibars container
            if wibars[s] == nil then wibars[s] = {} end

            -- Create the wibox
            local wibar = awful.wibar({position = position, screen = s})
            wibar.elements = {}

            -- Add widgets to the wibox
            local wibar_args = {layout = wibox.layout.align[layout]}
            for _, p in ipairs(elements) do
                local element_container = {layout = wibox.layout.fixed[layout]}
                for d, cfg in utils.value_with_cfg(p, true) do
                    local w = utils.require_submodule(
                                  'decorations/wibar/elements', d).init(s, cfg):register(
                        wibar.elements, wibar)
                    table.insert(element_container, w)
                end
                table.insert(wibar_args, element_container)
            end

            -- Add widgets to the wibox
            wibar:setup(wibar_args)
            wibars[s][config] = wibar

            wibar.visible = wibars_visible
        end,
        unregister_fn = function(s)
            local wibar = wibars[s][config]
            for d, _ in pairs(wibar.elements) do
                d:unregister(wibar.elements, wibar)
            end

            wibar.widget:reset()
            wibar:remove()
            wibar.elements = nil
            wibars[s][config] = nil
        end,
        update_fn = function(s)
            local wibar = wibars[s][config]

            for d, _ in pairs(wibar.elements) do d:update(wibar) end
        end,
        toggle = function(s)
            local wibar = wibars[s][config]
            wibar.visible = not wibar.visible
        end,
        toggle_widgets = function(s)
            local wibar = wibars[s][config]
            if wibar.visible and wibar.widgets_toggle then
                wibar.widgets_toggle()
            end
        end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
