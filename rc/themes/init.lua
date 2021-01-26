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
