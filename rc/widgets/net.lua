-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : net.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:01 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.widgets.utils')
local widgets = require('rc.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local net_icons = {down = '', up = ''}

local default_timeout = 3
local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal
local default_interface = 'eth0'
local default_value = 'down'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.net)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color
    local interface = warg.interface or default_interface
    local value = warg.value or default_value

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(_, args)
                    local val =
                        args['{' .. interface .. ' ' .. value .. '_kb}'] or -1
                    return utils.markup {fg_color = color, text = val .. 'kb'}
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local interface = warg.interface or default_interface
    local value = warg.value or default_value

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color, max = 50 * 1024},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(widget, args)
                    local val =
                        args['{' .. interface .. ' ' .. value .. '_kb}'] or -1
                    widget:emit_signal_recursive('widget::value_changed', val)
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = val .. 'kb'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
