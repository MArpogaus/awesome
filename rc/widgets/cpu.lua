-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : cpu.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:20 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.widgets.utils')
local widgets = require('rc.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local default_timeout = 1

local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

local step_width = 8
local step_spacing = 4

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.cpu)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = ''},
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    return utils.markup {
                        fg_color = color,
                        text = args[1] .. '%'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color

    local cpu_graph = wibox.widget {
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_height = (beautiful.desktop_widgets_arc_size or 220) / 5,
        color = fg_color,
        background_color = '#00000000',
        widget = wibox.widget.graph
    }
    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {
                widget = wibox.widget {
                    nil,
                    cpu_graph,
                    nil,
                    expand = 'outside',
                    layout = wibox.layout.align.horizontal
                },
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    local num_cpus = #args - 1
                    local width = (num_cpus + 1) * (step_width + step_spacing)

                    cpu_graph:clear()
                    cpu_graph:set_width(width)
                    for c = 2, #args do
                        cpu_graph:add_value(args[c] + 1)
                    end
                    cpu_graph:add_value(0)
                end
            },
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed', args[1]
                    )
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = args[1] .. '%'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
