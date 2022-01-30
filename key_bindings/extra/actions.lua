-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : actions.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 11:14:55 (Marcel Arpogaus)
-- @Changed: 2022-01-30 20:28:10 (Marcel Arpogaus)
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
-- grab environment
local capi = {screen = screen}

-- Standard awesome library
local awful = require('awful')

-- helper functions
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    browser = 'firefox',
    lock_command = 'light-locker-command -l'
}

-- [ local functions ] ---------------------------------------------------------
-- Delete the current tag
local function delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

-- Create a new tag at the end of the list
local function add_tag()
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
local function rename_tag()
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
local function move_tag(pos)
    local tag = awful.screen.focused().selected_tag
    if tonumber(pos) <= -1 then
        awful.tag.move(tag.index - 1, tag)
    else
        awful.tag.move(tag.index + 1, tag)
    end
end

-- taken from: https://github.com/lcpz/lain/blob/master/util/init.lua
-- On the fly useless gaps change
local function gaps_resize(amount, s, t)
    local scr = s or awful.screen.focused()
    local tag = t or scr.selected_tag
    tag.gap = tag.gap + tonumber(amount)
    awful.layout.arrange(scr)
end

-- taken from: https://github.com/Elv13/tyrannical/blob/master/shortcut.lua
local function fork_tag()
    local s = awful.screen.focused()
    local t = s.selected_tag
    if not t then return end

    local clients = t:clients()
    local t2 = awful.tag.add(t.name, awful.tag.getdata(t))

    t2:clients(clients)
    t2:view_only()
end

-- manage widgets
local function update_widgets()
    for s in capi.screen do s.update_decorations() end
end
local function toggle_decorations()
    local s = awful.screen.focused()
    s.toggle_decorations()
end
local function toggle_widgets()
    local s = awful.screen.focused()
    s.toggle_decorations_widgets()
end

-- change dpi
local function inc_dpi(inc)
    for s in capi.screen do
        s.dpi = s.dpi + inc
        utils.xconf_property_set('/Xft/DPI', math.floor(s.dpi))
    end
end
local function dec_dpi(dec) inc_dpi(-dec) end

-- [ module functions ] --------------------------------------------------------
module.init = function(_, config)
    config = utils.deep_merge(module.defaults, config)
    local actions = {}
    actions.global = {
        awesome = {
            ['lock screen'] = function()
                awful.spawn(config.lock_command)
            end,
            ['toggle decorations'] = toggle_decorations
        },
        client = {
            ['decrement useless gaps'] = function() gaps_resize(-2) end,
            ['increment useless gaps'] = function() gaps_resize(2) end
        },
        launcher = {
            ['launch Browser'] = function()
                awful.spawn(config.browser)
            end,
            ['launch rofi'] = function()
                awful.spawn('/usr/bin/rofi -show drun -modi drun')
            end
        },
        screenshot = {
            ['capture a screenshot of active window'] = function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -w')
            end,
            ['capture a screenshot of selection'] = function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -s')
            end
        },
        tag = {
            ['add new tag'] = add_tag,
            ['delete tag'] = delete_tag,
            ['fork tag'] = fork_tag,
            ['go back'] = awful.tag.history.restore,
            ['move tag to the left'] = function() move_tag(-1) end,
            ['move tag to the right'] = function() move_tag(1) end,
            ['rename tag'] = rename_tag
        },
        theme = {
            ['decrease dpi'] = function() dec_dpi(10) end,
            ['increase dpi'] = function() inc_dpi(10) end
        },
        widgets = {
            ['toggle widgets'] = toggle_widgets,
            ['update widgets'] = update_widgets
        }
    }

    actions.client = {}
    return actions
end

-- [ return module ] -----------------------------------------------------------
return module
