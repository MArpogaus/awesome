-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rc.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:54 (Marcel Arpogaus)
-- @Changed: 2021-10-14 20:08:48 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- This file is part of my modular awesome WM configuration.
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
-- ensure that there's always a client that has focus
require('awful.autofocus')

local gfs = require('gears.filesystem')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
-- configuration file
local default_modules = {
    'assets',
    'behavior',
    'decorations',
    'key_bindings',
    'layouts',
    'mouse_bindings',
    'screen',
    'tags',
    'theme'
}
local config = utils.load_config(default_modules)

-- [ local functions ] ---------------------------------------------------------
local function filter_keys(t, keys)
    local res = {}
    for _, k in ipairs(keys) do
        if t[k] then
            res[k] = t[k]
        else
            res[k] = {}
        end
    end
    return res
end
local function init_modules(cfg)
    for mod_name, mod_cfg in utils.value_with_cfg(cfg) do
        local mod = require(mod_name)
        if mod.depends_on then
            init_modules(filter_keys(cfg, mod.depends_on))
        end
        if not mod.initialized then
            mod:init(mod_cfg)
            mod.initialized = true
        end
    end
end
local function init_paths()
    local config_path = gfs.get_configuration_dir()
    for _, p in ipairs {'rc', 'config'} do
        local path = string.format(';%s%s/?.lua', config_path, p)
        path = path .. string.format(';%s%s/?/init.lua', config_path, p)
        package.path = package.path .. path
    end
end

-- [ initialization ] ----------------------------------------------------------
local function init()
    -- propergate pakg paths
    init_paths()

    -- rc modules
    local error_handling = require('error_handling')
    local session = require('rc.session')

    -- Initialize error handling
    error_handling:init()

    -- Initialize the session
    session:init(config.session, function()
        config.session = nil
        init_modules(config)
    end)
end
init()
