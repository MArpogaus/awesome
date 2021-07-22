-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : utils.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-23 16:01:08 (Marcel Arpogaus)
-- @Changed: 2021-07-22 10:23:29 (Marcel Arpogaus)
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local wibar_widgets = require('rc.widgets.wibar')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widgets = function(s, widgets, widgets_args)
    s.wibar_widget_containers = {}
    s.registered_wibar_widgets = {}

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
                             widgets_args[gears.string.split(w, '_')[1]] or {}
            warg = gears.table.clone(warg)
            warg.color = warg.color or fg_wibar_widgets[cidx]
            local widget_container, registered_widgets = wibar_widgets[w](warg)
            table.insert(s.wibar_widget_containers, widget_container)
            s.registered_wibar_widgets =
                gears.table
                    .join(s.registered_wibar_widgets, registered_widgets)
        elseif type(w) == 'table' and w.is_widget then
            table.insert(s.wibar_widget_containers, w)
        else
            error('unknown widget type')
        end
    end
    s.set_wibar_widget_opacity = function(opacity)
        for _, w in ipairs(s.wibar_widget_containers) do
            if w.has_registered_widgets then
                w.opacity = opacity
                w:emit_signal('widget::redraw_needed')
            end
        end
    end
    s.suspend_wibar_widgets = function()
        for _, w in ipairs(s.registered_wibar_widgets) do
            vicious.unregister(w, true)
            s.set_wibar_widget_opacity(0.5)
        end
    end
    s.activate_wibar_widgets = function()
        for _, w in ipairs(s.registered_wibar_widgets) do
            vicious.activate(w)
            s.set_wibar_widget_opacity(1)
        end
    end
    s.wibar_widgets_active = true
    s.toggle_wibar_widgets = function()
        if s.wibar_widgets_active then
            s.suspend_wibar_widgets()
        else
            s.activate_wibar_widgets()
        end
        s.wibar_widgets_active = not s.wibar_widgets_active
    end
    return s.wibar_widget_containers
end
module.unregister_wibar_widgets = function(s)
    for _, w in ipairs(s.registered_wibar_widgets) do vicious.unregister(w) end
    s.activate_wibar_widgets = nil
    s.registered_wibar_widgets = nil
    s.wibar_widget_containers = nil
    s.set_wibar_widget_opacity = nil
    s.suspend_wibar_widgets = nil
    s.toggle_wibar_widgets = nil
    s.wibar_widgets_active = nil
end
module.update_wibar_widgets = function(s)
    vicious.force(s.registered_wibar_widgets)
end

-- [ return module ] -----------------------------------------------------------
return module
