-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:53:14 (Marcel Arpogaus)
-- @Changed: 2021-10-09 11:22:29 (Marcel Arpogaus)
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
local capi = {client = client, root = root}

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')

local key_bindings = require('rc.key_bindings')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module function ] ---------------------------------------------------------
module.init = function(self)
    -- Default modkey.
    local modkey = key_bindings.config.modkey

    self.taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({modkey}, 1, function(t)
            if capi.client.focus then
                capi.client.focus:move_to_tag(t)
            end
        end), awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({modkey}, 3, function(t)
            if capi.client.focus then
                capi.client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

    self.client_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            capi.client.focus = c;
            c:raise()
            if awful.screen.focused().main_menu then
                awful.screen.focused().main_menu:hide()
            end
        end), awful.button({modkey}, 1, awful.mouse.client.move),
        awful.button({modkey}, 3, awful.mouse.client.resize))

    local root = gears.table.join(awful.button({}, 1, function()
        if awful.screen.focused().main_menu then
            awful.screen.focused().main_menu:hide()
        end
    end), awful.button({}, 3, function()
        if awful.screen.focused().main_menu then
            awful.screen.focused().main_menu:toggle()
        end
    end), awful.button({}, 4, awful.tag.viewnext),
                                  awful.button({}, 5, awful.tag.viewprev))
    capi.root.buttons(root)
end

-- [ return module ] -----------------------------------------------------------
return module
