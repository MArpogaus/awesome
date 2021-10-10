-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : utils.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:31 (Marcel Arpogaus)
-- @Changed: 2021-10-10 18:53:13 (Marcel Arpogaus)
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
-- Standard awesome library
local awful = require('awful')
local gears = require('gears')
local gfs = require('gears.filesystem')

local lgi = require('lgi')
local cairo = lgi.cairo

-- [ local variables ] ---------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
function module.xrdb_set_value(key, value)
    awful.spawn
        .with_shell(string.format('xrdb -merge <<< "%s:%s"', key, value))
end
function module.xconf_property_set(property, value, sleep)
    local xconf = string.format(
        'xfconf-query -c xsettings --property %s --set \'%s\'', property, value)
    if sleep then xconf = string.format('sleep %.1f && %s', sleep, xconf) end
    awful.spawn.with_shell(xconf)
end

-- Load configuration file
function module.load_config(config_file)
    local config
    if gfs.file_readable(gfs.get_configuration_dir() ..
                             (config_file or 'config') .. '.lua') then
        config = require(config_file or 'config')
    end
    return config
end

-- deep merge two tables
function module.deep_merge(t1, t2, max_level)
    local res = gears.table.clone(t1, true)
    if max_level == nil then max_level = 5 end
    for k, v in pairs(t2) do
        if max_level > 0 and type(k) == 'string' and type(v) == 'table' then
            res[k] = module.deep_merge(res[k] or {}, v, max_level - 1)
        else
            res[k] = v
        end
    end
    return res
end

function module.require_submodule(path, file, ignore_error)
    local config_path = gfs.get_configuration_dir()
    local file_name
    for _, pre in ipairs {'config', 'rc'} do
        file_name = string.format('%s/%s/%s', pre, path, file)
        if gfs.file_readable(config_path .. file_name .. '.lua') or
            gfs.file_readable(config_path .. file_name .. '/init.lua') then
            return require(file_name:gsub('/', '.'))
        end
    end
    if ignore_error then
        return {init = function(_) return {} end}
    else
        error(
            string.format('submodule \'%s\' not found in \'%s\'.', file, path))
    end
end

function module.value_with_cfg(t, sorted)
    local i = nil
    local keys = gears.table.join(gears.table.from_sparse(t),
                                  gears.table.keys_filter(t, 'table'))
    if sorted then table.sort(keys) end
    local function iter()
        local k
        i, k = next(keys, i)
        if k then
            return gears.string.split(k, '-')[2] or k, t[k] or {}
        else
            return nil
        end

    end
    return iter
end

-- Helper functions for modifying hex colors -----------------------------------
function module.darker(color, ratio)
    local pattern = gears.color(color)
    local kind = pattern:get_type()
    ratio = 1 - ratio / 100
    if kind == 'SOLID' then
        local _, r, g, b, a = pattern:get_rgba()
        r = math.min(math.floor(ratio * r * 0xFF), 0xFF)
        g = math.min(math.floor(ratio * g * 0xFF), 0xFF)
        b = math.min(math.floor(ratio * b * 0xFF), 0xFF)
        a = math.floor(a * 0xFF)
        return string.format('#%02x%02x%02x%02x', r, g, b, a) -- cairo.Pattern.create_rgba(r,g,b,a)
    else
        return color
    end
end
function module.is_dark(color)
    local pattern = gears.color(color)
    local kind = pattern:get_type()

    if kind == 'SOLID' then
        local _, r, g, b, _ = pattern:get_rgba()
        if (r + b + g) > 1.5 then
            return true
        else
            return false
        end
    else
        return
    end
end
function module.reduce_contrast(color, ratio)
    ratio = ratio or 50
    if module.is_dark(color) then
        return module.darker(color, -ratio)
    else
        return module.darker(color, ratio)
    end
end
function module.set_alpha(color, alpha)
    local pattern = gears.color(color)
    local kind = pattern:get_type()

    if kind == 'SOLID' then
        local _, r, g, b, _ = pattern:get_rgba()
        return cairo.Pattern.create_rgba(r, g, b, alpha / 100)
    else
        return color
    end
end

-- hot reload theme
function module.update_theme()
    -- rc modules
    local assets = require('rc.assets')
    local screen = require('rc.screen')
    local theme = require('rc.theme')

    theme.update()
    assets.apply()
    screen.update_all()

    collectgarbage()
end

-- [ return module ]------------------------------------------------------------
return module
