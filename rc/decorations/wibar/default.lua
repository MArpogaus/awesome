-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-08-09 08:47:24 (Marcel Arpogaus)
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

local gen_element = {
    mainmenu = function(_) end,
    taglist = function(_) end,
    promptbox = function(_) end,
    tasklist = function(_) end,
    keyboardlayout = function(_) end,
    systray = function(_) end,
    widgets = function(_) end
}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, widgets_args)
    local wibar_elements = {}

    local position = config.position or 'top'

    local left_widgets = config.left
    local middle_widgets = config.middle
    local right_widgets = config.right

    local layouts = wibox.layout.fixed.horizontal
    local mykeyboardlayout = awful.widget.keyboardlayout()
    local decoration = abstract_decoration.new {
        register_fn = function(s)
            if config.screens and
                not gears.table.hasitem(config.screens, s.index) then
                return
            end
            -- Create the wibox
            s.mywibar = awful.wibar({position = position, screen = s})

            -- menus
            -- if mainmenu then
            --     s.mainmenu = awful.widget.launcher(
            --         {image = beautiful.awesome_icon, menu = mainmenu})
            -- end
            -- if exitmenu then
            --     s.exitmenu = awful.widget.launcher(
            --         {
            --             image = beautiful.exitmenu_icon or
            --                 menubar.utils.lookup_icon('system-shutdown'),
            --             menu = exitmenu
            --         })
            -- end

            -- Add widgets to the wibox
            local left_widget_container = {}
            left_widget_container.layout = layouts
            for d, cfg in utils.value_with_cfg(left) do
                -- local w = utils.require_submodule(
                --               'rc/decorations/wibar/elements', d).init(cfg)
                --               .register(wibar_elements, s)
                -- table.insert(left_widget_container, w)
            end
            table.insert(left_widget_container, s.promptbox)

            local middle_widget_container = {}
            middle_widget_container.layout = layouts
            for d, cfg in utils.value_with_cfg(middle) do
                -- local w = utils.require_submodule(
                --               'rc/decorations/wibar/elements', d).init(cfg)
                --               .register(wibar_elements, s)
                -- table.insert(middle_widget_container, w)
            end

            local right_widget_container = {}
            right_widget_container.layout = layouts
            for d, cfg in utils.value_with_cfg(right) do
                -- local w = utils.require_submodule(
                --               'rc/decorations/wibar/elements', d).init(cfg)
                --               .register(wibar_elements, s)
                -- table.insert(right_widget_container, w)
            end

            -- Add widgets to the wibox
            s.mywibar:setup{
                layout = layouts,
                left_widget_container, -- Left widgets
                middle_widget_container, -- Middle widget
                right_widget_container -- Right widgets
            }
        end,
        unregister_fn = function(s)
            for _, d in pairs(wibar_elements) do
                d.unregister(wibar_elements, s)
            end

            s.mywibar.widget:reset()
            s.mywibar:remove()
            s.mywibar = nil
        end,
        update_fn = function(s) utils.update_wibar_widgets(s) end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
