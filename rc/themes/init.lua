-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:02 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
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
        for _, path in ipairs {themes_path, config_path .. '/themes'} do
            theme_file = string.format('%s/%s/theme.lua', path, config.theme)
            if gfs.file_readable(theme_file) then
                break
            end
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
