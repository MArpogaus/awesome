-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:55 (Marcel Arpogaus)
-- @Changed: 2021-10-04 08:44:21 (Marcel Arpogaus)
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

local vicious = require('vicious')

local utils = require('decorations.widgets.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local function create_widget(widget_def, widget_container, timeout)
    local registered_widgets = {}

    local widget_container_args = widget_def.container_args or {}
    for key, w in pairs(widget_def.widgets) do
        -- define widget
        local widget
        if w.widget then
            widget = w.widget
        else
            widget = wibox.widget.textbox()
        end
        widget_container_args[key] = widget

        -- register widget
        if w.wtype and w.format then
            vicious.register(widget, w.wtype, w.format, timeout, w.warg)
            -- bookkeeping to unregister widget
            table.insert(registered_widgets, widget)
        end
    end

    -- return widget container
    local container = widget_container(widget_container_args)
    container.unregister = function()
        for _, w in ipairs(registered_widgets) do vicious.unregister(w) end
    end
    container.suspend = function()
        for _, w in ipairs(registered_widgets) do
            vicious.unregister(w, true)
        end
    end
    container.activate = function()
        for _, w in ipairs(registered_widgets) do vicious.activate(w) end
    end
    container.update = function() vicious.force(registered_widgets) end
    return container
end

-- [ module functions ] --------------------------------------------------------
module.new = function(wtype, widget_def_fn)
    local function widget_generator(s, wargs)
        wargs = wargs or {}
        local widget_def = widget_def_fn(s, wargs)
        local timeout = wargs.timeout or widget_def.default_timeout
        if wtype == 'wibar' then
            return
                create_widget(widget_def, utils.create_wibar_widget, timeout)
        elseif wtype == 'arc' then
            return create_widget(widget_def, utils.create_arc_widget, timeout)
        else
            return create_widget(widget_def, widget_def.widget_container,
                                 timeout)
        end
    end

    return widget_generator
end

-- [ return module ] -----------------------------------------------------------
return module
