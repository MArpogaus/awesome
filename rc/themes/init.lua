--------------------------------------------------------------------------------
-- @File:   tags.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-30 09:33:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 14:43:29
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] -------------------------------------------------------
local os = os

local beautiful = require('beautiful')
local gears = require('gears')
local gfs = require('gears.filesystem')
local menubar = require('menubar')

local assets = require('rc.themes.decorations.assets')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

-- [ local functions ] ---------------------------------------------------------
local function add_color_scheme(theme)
    if theme.cs then return theme end
    -- abuse table keys to generate a set of used colors
    local color_set = {}
    for _, v in pairs(theme) do
        local c = gears.color.ensure_pango_color(v, 0)
        if c ~= 0 then color_set[c] = true end
    end
    color_set[theme.bg_normal] = nil
    color_set[theme.fg_normal] = nil
    theme.cs = {
        bg = theme.bg_normal,
        fg = theme.fg_normal,
        colors = gears.table.find_keys(
            color_set, function(...) return true end
        )
    }

    return theme
end
local function decorate_theme(config, theme)
    add_color_scheme(theme)
    assets[config.theme_assets or 'default'](theme)
    gears.debug.print_warning(gears.debug.dump_return(theme.widgets))
end
-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local theme_file
    if config.theme then
        for _, path in ipairs {themes_path, config_path .. '/themes'} do
            theme_file = string.format('%s/%s/theme.lua', path, config.theme)
            if gfs.file_readable(theme_file) then break end
        end
    end
    if not beautiful.init(theme_file) then
        beautiful.init(themes_path .. '/default/theme.lua')
    end
end

-- [ return module ] -----------------------------------------------------------
return module
