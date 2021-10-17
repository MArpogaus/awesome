-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : assets.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-19 15:38:22 (Marcel Arpogaus)
-- @Changed: 2021-01-27 08:40:03 (Marcel Arpogaus)
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
local beautiful = require('beautiful')
local theme_assets = require('beautiful.theme_assets')
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function()
    local theme = beautiful.get()

    -- Generate Awesome icon:
    theme.awesome_icon = theme.awesome_icon or
                             theme_assets.awesome_icon(theme.menu_height,
                                                       theme.bg_focus,
                                                       theme.fg_focus)

    -- Recolor Layout icons:
    theme = theme_assets.recolor_layout(theme, theme.fg_normal)

    -- Generate taglist squares:
    local taglist_square_size = theme.taglist_square_size or 4
    theme.taglist_squares_sel = theme.taglist_squares_sel or
                                    theme_assets.taglist_squares_sel(
                                        taglist_square_size, theme.fg_normal)
    theme.taglist_squares_unsel = theme.taglist_squares_unsel or
                                      theme_assets.taglist_squares_unsel(
                                          taglist_square_size, theme.fg_normal)

    -- Recolor titlebar icons:
    theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, 'normal')
    theme = theme_assets.recolor_titlebar(theme,
                                          utils.darker(theme.fg_normal, -60),
                                          'normal', 'hover')
    theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'normal',
                                          'press')
    theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'focus')
    theme = theme_assets.recolor_titlebar(theme,
                                          utils.darker(theme.fg_focus, -60),
                                          'focus', 'hover')
    theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'focus',
                                          'press')

    return theme
end

-- [ return module ] -----------------------------------------------------------
return module
