-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : /home/marcel/.config/awesome/themes/decorations/assets.lua 
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-19 15:38:22 (Marcel Arpogaus)
-- @Changed: 2021-01-25 17:58:24 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local beautiful = require('beautiful')
local theme_assets = require('beautiful.theme_assets')
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function()
    local theme = beautiful.get()

    -- Generate Awesome icon:
    theme.awesome_icon = theme.awesome_icon or
                             theme_assets.awesome_icon(
            theme.menu_height, theme.bg_focus, theme.fg_focus
        )

    -- Recolor Layout icons:
    theme = theme_assets.recolor_layout(theme, theme.fg_normal)

    -- Generate taglist squares:
    local taglist_square_size = theme.taglist_square_size or 4
    theme.taglist_squares_sel = theme.taglist_squares_sel or
                                    theme_assets.taglist_squares_sel(
            taglist_square_size, theme.fg_normal
        )
    theme.taglist_squares_unsel = theme.taglist_squares_unsel or
                                      theme_assets.taglist_squares_unsel(
            taglist_square_size, theme.fg_normal
        )

    -- Recolor titlebar icons:
    theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, 'normal')
    theme = theme_assets.recolor_titlebar(
        theme, utils.darker(theme.fg_normal, -60), 'normal', 'hover'
    )
    theme = theme_assets.recolor_titlebar(
        theme, theme.fg_focus, 'normal', 'press'
    )
    theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'focus')
    theme = theme_assets.recolor_titlebar(
        theme, utils.darker(theme.fg_focus, -60), 'focus', 'hover'
    )
    theme = theme_assets.recolor_titlebar(
        theme, theme.fg_focus, 'focus', 'press'
    )

    return theme
end

-- [ return module ] -----------------------------------------------------------
return module
