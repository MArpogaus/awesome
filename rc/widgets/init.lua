-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:55 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local wibox = require('wibox')

local vicious = require('vicious')

local utils = require('rc.widgets.utils')

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
    container.has_registered_widgets = registered_widgets ~= nil
    return container, registered_widgets
end

-- [ module functions ] --------------------------------------------------------
module.new = function(args)
    local widget_generator = {}

    for k, wd in pairs(args) do
        widget_generator['create_' .. k .. '_widget'] =
            function(wargs)
                wargs = wargs or {}
                local widget_def = wd(wargs)
                local timeout = wargs.timeout or widget_def.default_timeout
                if k == 'wibar' then
                    return create_widget(
                        widget_def, utils.create_wibar_widget, timeout
                    )
                elseif k == 'arc' then
                    return create_widget(
                        widget_def, utils.create_arc_widget, timeout
                    )
                else
                    return create_widget(
                        widget_def, widget_def.widget_container, timeout
                    )
                end
            end
    end

    return widget_generator
end

-- [ return module ] -----------------------------------------------------------
return module
