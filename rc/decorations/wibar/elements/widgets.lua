-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : widgets.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:36:38 (Marcel Arpogaus)
-- @Changed: 2021-09-28 09:10:24 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.utils')

local abstract_element = require('rc.decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local wibar_widgets_active_inital = true

-- [ module functions ] --------------------------------------------------------
module.init = function(s, config)
    local widgets = config.widgets or {wibox.widget.textclock()}
    local widgets_args = config.widgets_args or {}
    local layout = config.layout or wibox.layout.fixed.horizontal

    local wibar_widgets_active = true
    local wibar_widget_container = {layout = layout}
    local registered_wibar_widgets = setmetatable({}, {__mode = 'v'})

    local widget_set_opacity = function(opacity)
        for _, w in ipairs(wibar_widget_container.children) do
            if w.has_registered_widgets then
                w.opacity = opacity
                w:emit_signal('widget::redraw_needed')
            end
        end
    end
    local widgets_suspend = function()
        for _, w in ipairs(registered_wibar_widgets) do
            vicious.unregister(w, true)
            widget_set_opacity(0.5)
        end
    end
    local widgets_activate = function()
        for _, w in ipairs(registered_wibar_widgets) do
            vicious.activate(w)
            widget_set_opacity(1)
        end
    end
    local widgets_set_state = function(state)
        if state then
            widgets_activate()
        else
            widgets_suspend()
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
                    local widget_container, registered_widgets =
                        utils.require_submodule('decorations/widgets/wibar', w)
                            .init(s, warg)
                    table.insert(wibar_widget_container, widget_container)
                    registered_wibar_widgets =
                        gears.table.join(registered_wibar_widgets,
                                         registered_widgets)
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
            for i, w in ipairs(registered_wibar_widgets) do
                vicious.unregister(w)
                table.remove(registered_wibar_widgets, i)
            end
            registered_wibar_widgets = nil
            wibar_widget_container:reset()
            wibar_widget_container:remove()
            wibar_widget_container = nil
            wibar.widgets_toggle = nil
        end,
        update_fn = function(_) vicious.force(registered_wibar_widgets) end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
