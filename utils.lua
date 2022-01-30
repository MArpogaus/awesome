-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : utils.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:31 (Marcel Arpogaus)
-- @Changed: 2022-01-30 21:22:30 (Marcel Arpogaus)
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
        return module.darker(color, ratio)
    else
        return module.darker(color, -ratio)
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
function module.get_pkg_name(prefix, pkg, postfix)
    if not pkg:find('%.') then pkg = prefix .. pkg end
    if postfix ~= nil then pkg = pkg .. postfix end
    return pkg
end

-- hot reload theme
function module.update_theme()
    -- rc modules
    local assets = require('assets')
    local screen = require('screen')
    local theme = require('theme')

    theme.update()
    if assets.apply then assets.apply() end
    screen.update_all()

    collectgarbage()
end

-- [ return module ]------------------------------------------------------------
return module
