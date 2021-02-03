-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:02 (Marcel Arpogaus)
-- @Changed: 2021-01-27 14:28:05 (Marcel Arpogaus)
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

-- [ local objects ] -----------------------------------------------------------
local module = {}
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local theme_file
    if config.theme then
        for _, path in ipairs {
            themes_path,
            config_path .. '/config/themes',
            config_path .. '/rc/themes'
        } do
            theme_file = string.format('%s/%s/theme.lua', path, config.theme)
            if gfs.file_readable(theme_file) then break end
        end
    end
    if not beautiful.init(theme_file) then
        beautiful.init(themes_path .. '/default/theme.lua')
    end
    if config.theme_overwrite then
        gears.table.crush(beautiful.get(), config.theme_overwrite)
    end
end

-- [ return module ] -----------------------------------------------------------
return module
