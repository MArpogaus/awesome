-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:02 (Marcel Arpogaus)
-- @Changed: 2021-07-18 22:09:07 (Marcel Arpogaus)
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
-- [ required modules ] -------------------------------------------------------
local beautiful = require('beautiful')
local gears = require('gears')
local gfs = require('gears.filesystem')
local protected_call = require('gears.protected_call')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    if config.name then
        for _, path in ipairs {
            themes_path,
            config_path .. '/config/themes',
            config_path .. '/rc/themes'
        } do
            local theme_file = string.format('%s/%s/theme.lua', path,
                                             config.name)
            if gfs.file_readable(theme_file) then
                module.load_theme = function()
                    return protected_call(dofile, theme_file)
                end
            end
        end
    end
    if not module.load_theme then
        beautiful.init(themes_path .. '/default/theme.lua')
    else
        beautiful.init(module.load_theme())
    end
    if config.overload then
        gears.table.crush(beautiful.get(), config.overload)
    end
    module.update = function()
        if module.load_theme then
            -- reset cached colors
            beautiful.gtk.cached_theme_variables = nil
            gears.table.crush(beautiful.get(), module.load_theme())
            gears.table.crush(beautiful.get(), config.overload)
        end
    end
end

-- [ return module ] -----------------------------------------------------------
return module
