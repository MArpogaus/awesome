-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : volume.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:10 (Marcel Arpogaus)
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

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-volume-off
fa_vol_icons[1] = '' -- fa-volume-down
fa_vol_icons[2] = '' -- fa-volume-up

local default_timeout = 1

local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

local default_device = 'Master'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.volume)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color
    local device = warg.device or default_device

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {
                widget = utils.fa_ico(color, 'N/A'),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico = fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return utils.fa_markup(color, ico)
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                    else
                        vol = args[1] .. '%'
                    end
                    return utils.fa_markup(color, vol)
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local device = warg.device or default_device

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {
                widget = utils.create_arc_icon(fg_color, 'N/A', 150),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico = fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return utils.fa_markup(fg_color, ico, math.floor(150 / 8))
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(widget, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                        widget:emit_signal_recursive('widget::value_changed', 0)
                    else
                        vol = args[1] .. '%'
                        widget:emit_signal_recursive(
                            'widget::value_changed', args[1]
                        )
                    end
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = vol
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
