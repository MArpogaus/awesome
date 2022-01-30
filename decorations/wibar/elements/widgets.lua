-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : widgets.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:36:38 (Marcel Arpogaus)
-- @Changed: 2022-01-30 21:26:13 (Marcel Arpogaus)
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
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local utils = require('utils')

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local wibar_widgets_active_inital = true

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    widgets = {wibox.widget.textclock()},
    widgets_args = {},
    layout = wibox.layout.fixed.horizontal
}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, config)
    config = utils.deep_merge(module.defaults, config or {}, 0)
    local widgets = config.widgets
    local widgets_args = config.widgets_args
    local layout = config.layout

    local wibar_widgets_active = true
    local wibar_widget_container = {layout = layout}

    local widget_set_opacity = function(fn, opacity)
        for _, w in ipairs(wibar_widget_container.children) do
            if w[fn] then
                w[fn]()
                w.opacity = opacity
                w:emit_signal('widget::redraw_needed')
            end
        end
    end
    local widgets_set_state = function(state)
        if state then
            widget_set_opacity('activate', 1.0)
        else
            widget_set_opacity('suspend', 0.5)
        end
        wibar_widgets_active_inital = state
        wibar_widgets_active = state
    end
    return abstract_element.new {
        register_fn = function(wibar)

            local fg_wibar_widgets

            if beautiful.fg_wibar_widgets and #beautiful.fg_wibar_widgets then
                fg_wibar_widgets = beautiful.fg_wibar_widgets
            else
                fg_wibar_widgets = {beautiful.fg_normal}
            end
            local midx = #fg_wibar_widgets
            for i, w in pairs(widgets) do
                if type(w) == 'string' then
                    local cidx = (i - 1) % midx + 1
                    local warg = widgets_args[w] or
                                     widgets_args[gears.string.split(w, '_')[1]] or
                                     {}
                    warg = gears.table.clone(warg)
                    warg.color = warg.color or fg_wibar_widgets[cidx]
                    local widget_container = require(
                                                 utils.get_pkg_name(
                            'decorations.widgets.wibar.', w)).init(s, warg)
                    table.insert(wibar_widget_container, widget_container)
                elseif type(w) == 'table' and w.is_widget then
                    table.insert(wibar_widget_container, w)
                else
                    error('unknown widget type')
                end
            end
            wibar_widget_container = wibox.widget(wibar_widget_container)
            wibar.widgets_toggle = function()
                widgets_set_state(not wibar_widgets_active)
            end
            widgets_set_state(wibar_widgets_active_inital)
            return wibar_widget_container
        end,
        unregister_fn = function(wibar)
            for _, w in ipairs(wibar_widget_container.children) do
                if w.unregister then w.unregister() end
            end
            wibar_widget_container:reset()
            wibar_widget_container:remove()
            wibar_widget_container = nil
            wibar.widgets_toggle = nil
        end,
        update_fn = function(_)
            for _, w in ipairs(wibar_widget_container.children) do
                if w.update then w.update() end
            end
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
