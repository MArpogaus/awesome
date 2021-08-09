-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : widgets.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:36:38 (Marcel Arpogaus)
-- @Changed: 2021-08-09 15:22:00 (Marcel Arpogaus)
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

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local widgets = config.widgets or {wibox.widget.textclock()}
    local widgets_args = config.widgets_args or {}
    local layout = config.layout or wibox.layout.fixed.horizontal

    local wibar_widget_containers = {layout = layout}
    local registered_wibar_widgets = setmetatable({}, {__mode = 'kv'})
    return abstract_element.new {
        register_fn = function(s)

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
                            .init(warg)
                    table.insert(wibar_widget_containers, widget_container)
                    registered_wibar_widgets =
                        gears.table.join(registered_wibar_widgets,
                                         registered_widgets)
                elseif type(w) == 'table' and w.is_widget then
                    table.insert(wibar_widget_containers, w)
                else
                    error('unknown widget type')
                end
            end
            s.set_wibar_widget_opacity =
                function(opacity)
                    for _, w in ipairs(wibar_widget_containers) do
                        if w.has_registered_widgets then
                            w.opacity = opacity
                            w:emit_signal('widget::redraw_needed')
                        end
                    end
                end
            s.suspend_wibar_widgets = function()
                for _, w in ipairs(registered_wibar_widgets) do
                    vicious.unregister(w, true)
                    s.set_wibar_widget_opacity(0.5)
                end
            end
            s.activate_wibar_widgets = function()
                for _, w in ipairs(registered_wibar_widgets) do
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
            return wibar_widget_containers

        end,
        unregister_fn = function(s)
            for i, w in ipairs(registered_wibar_widgets) do
                vicious.unregister(w)
                table.remove(registered_wibar_widgets, i)
            end
            registered_wibar_widgets = nil
            for i, c in ipairs(wibar_widget_containers) do
                c:reset()
                table.remove(wibar_widget_containers, i)
            end
            wibar_widget_containers = nil
            s.activate_wibar_widgets = nil
            s.set_wibar_widget_opacity = nil
            s.suspend_wibar_widgets = nil
            s.toggle_wibar_widgets = nil
            s.wibar_widgets_active = nil
        end,
        update_fn = function(_) vicious.force(registered_wibar_widgets) end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
