-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : defaults.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-20 08:38:14 (Marcel Arpogaus)
-- @Changed: 2021-01-21 18:48:42 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module objects ] ----------------------------------------------------------
-- module.top_bar_height =  beautiful.titlebar_size
-- module.bottom_bar_height =  beautiful.titlebar_size

-- module.ico_width =  beautiful.titlebar_size
module.icon_margin_left = 12
module.icon_margin_right = 8
module.systray_icon_spacing = module.icon_margin_left

module.desktop_widgets_arc_size = 220
module.desktop_widgets_arc_spacing = module.desktop_widgets_arc_size / 2
module.desktop_widgets_vertical_spacing = 170
module.desktop_widgets_time_font_size = 50
module.desktop_widgets_date_font_size = module.desktop_widgets_time_font_size /
                                            3
module.desktop_widgets_weather_font_size = 50

module.widgets = {
    wibar = {

        beautiful.fg_normal,

        cal = beautiful.fg_normal,
        clock = beautiful.fg_focus
    },
    desktop = {
        arcs = {beautiful.fg_normal},
        clock = {
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            time = beautiful.fg_normal,
            day = beautiful.fg_focus,
            date = beautiful.fg_focus,
            month = beautiful.fg_focus
        },
        weather = {fg = beautiful.fg_normal}
    }
}

-- [ return module ] -----------------------------------------------------------
return module
