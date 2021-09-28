-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : utils.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:31 (Marcel Arpogaus)
-- @Changed: 2021-09-28 12:12:48 (Marcel Arpogaus)
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
local capi = {screen = screen, client = client, awesome = awesome}

-- Standard awesome library
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local gfs = require('gears.filesystem')

local lgi = require('lgi')
local cairo = lgi.cairo

-- [ local variables ] ---------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
-- ref.: https://stackoverflow.com/questions/62286322/grouping-windows-in-the-tasklist
local function client_label(c)
    local active_theme = beautiful.get()
    local sticky = active_theme.tasklist_sticky or '▪'
    local ontop = active_theme.tasklist_ontop or '⌃'
    local above = active_theme.tasklist_above or '▴'
    local below = active_theme.tasklist_below or '▾'
    local floating = active_theme.tasklist_floating or '✈'
    local minimized = active_theme.tasklist_maximized or '-'
    local maximized = active_theme.tasklist_maximized or '+'
    local maximized_horizontal = active_theme.tasklist_maximized_horizontal or
                                     '⬌'
    local maximized_vertical = active_theme.tasklist_maximized_vertical or
                                   '⬍'

    local name = c.name
    if c.sticky then name = sticky .. name end

    if c.ontop then
        name = ontop .. name
    elseif c.above then
        name = above .. name
    elseif c.below then
        name = below .. name
    end

    if c.minimized then name = minimized .. name end
    if c.maximized then
        name = maximized .. name
    else
        if c.maximized_horizontal then
            name = maximized_horizontal .. name
        end
        if c.maximized_vertical then name = maximized_vertical .. name end
        if c.floating then name = floating .. name end
    end

    return name
end
local function set_xconf(property, value, sleep)
    local xconf = string.format(
        'xfconf-query -c xsettings --property %s --set \'%s\'', property, value)
    if sleep then xconf = string.format('sleep %.1f && %s', sleep, xconf) end
    awful.spawn.with_shell(xconf)
end

-- [ module functions ] --------------------------------------------------------
function module.xrdb_set_value(key, value)
    awful.spawn
        .with_shell(string.format('xrdb -merge <<< "%s:%s"', key, value))
end

-- Load configuration file
function module.load_config(config_file)
    local config = require('rc.defaults')
    if gfs.file_readable(gfs.get_configuration_dir() ..
                             (config_file or 'config') .. '.lua') then
        config = module.deep_merge(config, require(config_file or 'config'), 1)
    end
    return config
end
function module.sleep(n) os.execute('sleep ' .. tonumber(n)) end

-- deep merge two tables
function module.deep_merge(t1, t2, max_level)
    if max_level == nil then max_level = 5 end
    for k, v in pairs(t2) do
        if max_level > 0 and type(k) == 'string' and type(v) == 'table' and
            not v[1] then
            t1[k] = module.deep_merge(t1[k] or {}, v, max_level - 1)
        else
            t1[k] = v
        end
    end
    return t1
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

-- Delete the current tag
function module.delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

-- Create a new tag at the end of the list
function module.add_tag()
    awful.prompt.run {
        prompt = 'New tag name: ',
        textbox = awful.screen.focused().promptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            awful.tag.add(new_name, {
                screen = awful.screen.focused(),
                layout = awful.layout.suit.floating
            }):view_only()
        end
    }
end

-- Rename the current tag
function module.rename_tag()
    awful.prompt.run {
        prompt = 'Rename tag: ',
        textbox = awful.screen.focused().promptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then t.name = new_name end
        end
    }
end

-- taken from: https://github.com/lcpz/lain/blob/master/util/init.lua
-- Move current tag
-- pos in {-1, 1} <-> {previous, next} tag position
function module.move_tag(pos)
    local tag = awful.screen.focused().selected_tag
    if tonumber(pos) <= -1 then
        awful.tag.move(tag.index - 1, tag)
    else
        awful.tag.move(tag.index + 1, tag)
    end
end

-- taken from: https://github.com/lcpz/lain/blob/master/util/init.lua
-- On the fly useless gaps change
function module.gaps_resize(amount, s, t)
    local scr = s or awful.screen.focused()
    local tag = t or scr.selected_tag
    tag.gap = tag.gap + tonumber(amount)
    awful.layout.arrange(scr)
end

-- taken from: https://github.com/Elv13/tyrannical/blob/master/shortcut.lua
function module.fork_tag()
    local s = awful.screen.focused()
    local t = s.selected_tag
    if not t then return end

    local clients = t:clients()
    local t2 = awful.tag.add(t.name, awful.tag.getdata(t))

    t2:clients(clients)
    t2:view_only()
end
function module.get_screen(i)
    local sc = capi.screen.count()
    if i > sc then i = 1 end

    return capi.screen[i]
end
function module.move_to_screen(c)
    if not c then return end

    local s = c.screen.index + 1

    local s1 = awful.screen.focused()
    local s2 = module.get_screen(s)

    if s1 == s2 then return end

    local t1 = s1.selected_tag

    local t2 = awful.tag.find_by_name(s2, t1.name)
    if t2 == nil then
        local td = awful.tag.getdata(t1)
        t2 = awful.tag.add(t1.name, gears.table.clone(td), {screen = s})
        td.instances[s] = t2
    end

    c:move_to_screen()
    c:move_to_tag(t2)
    t2:view_only()
end
function module.client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 1000}})
        end
    end
end

function module.client_stack_toggle_fn()
    local cl_menu
    return function(c)
        if cl_menu then
            cl_menu:hide()
            cl_menu = nil
        else
            local client_num = 0
            local client_list = {}
            for i, cl in ipairs(capi.client.get()) do
                if cl.class == c.class then
                    client_num = client_num + 1
                    client_list[i] = {
                        client_label(cl),
                        function()
                            capi.client.focus = cl
                            cl:tags()[1]:view_only()
                            cl:raise()
                        end,
                        cl.icon
                    }
                end
            end

            if client_num > 1 then
                cl_menu = awful.menu({
                    items = client_list,
                    theme = {width = 1000}
                })
                cl_menu:show()
            else
                capi.client.focus = c
                c:tags()[1]:view_only()
                c:raise()
            end
        end
    end
end

function module.application_switcher()
    awful.menu.menu_keys.down = {'Tab', 'Down'}
    awful.menu.client_list {
        theme = {width = 1000, height = 64},
        item_args = {keygrabber = true, coords = {x = 0, y = 0}},
        -- TODO: why not working?
        filter = function(c)
            return awful.widget.tasklist.filter.currenttags(c, c.screen)
        end
    }
end

-- change dpi
function module.inc_dpi(inc)
    for s in capi.screen do
        s.dpi = s.dpi + inc
        set_xconf('/Xft/DPI', math.floor(s.dpi))
    end
end
function module.dec_dpi(dec) module.inc_dpi(-dec) end

-- https://github.com/awesomeWM/awesome/blob/7a8fa9d27a7907ab81e60274c925ba65d10015aa/lib/awful/screen/dpi.lua#L228
function module.get_xft_dpi()
    local xft_dpi = tonumber(capi.awesome.xrdb_get_value('', 'Xft.dpi')) or
                        false

    return xft_dpi
end

-- manage widgets
function module.update_widgets()
    for s in capi.screen do s.update_decorations() end
end
function module.toggle_decorations()
    local s = awful.screen.focused()
    s.toggle_decorations()
end
function module.toggle_widgets()
    local s = awful.screen.focused()
    s.toggle_decorations_widgets()
end

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
