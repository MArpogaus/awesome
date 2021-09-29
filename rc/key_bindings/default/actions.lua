-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : actions.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 11:14:55 (Marcel Arpogaus)
-- @Changed: 2021-09-29 11:59:19 (Marcel Arpogaus)
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
local capi = {awesome = awesome}

-- standard awesome library
local awful = require('awful')

-- theme handling library
local menubar = require('menubar')

-- hotkeys widget
local hotkeys_popup = require('awful.hotkeys_popup').widget

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(applications)
    local actions = {}
    actions.global = {
        awesome = {
            ['quit awesome'] = capi.awesome.quit,
            ['reload awesome'] = capi.awesome.restart,
            ['reload theme'] = utils.update_theme,
            ['show help'] = hotkeys_popup.show_help,
            ['show main menu'] = function()
                if awful.screen.focused().main_menu then
                    awful.screen.focused().main_menu:toggle()
                end
            end,
            ['lua execute prompt'] = function()
                awful.prompt.run {
                    prompt = 'Run Lua code: ',
                    textbox = awful.screen.focused().promptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() ..
                        '/history_eval'
                }
            end
        },
        client = {
            ['focus next by index'] = function()
                awful.client.focus.byidx(1)
            end,
            ['focus previous by index'] = function()
                awful.client.focus.byidx(-1)
            end,
            ['jump to urgent client'] = awful.client.urgent.jumpto,
            ['swap with next client by index'] = function()
                awful.client.swap.byidx(1)
            end,
            ['swap with previous client by index'] = function()
                awful.client.swap.byidx(-1)
            end,
            ['go back'] = function()
                awful.client.focus.history.previous()
                if client.focus then client.focus:raise() end
            end,
            ['restore minimized'] = function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal('request::activate', 'key.unminimize',
                                  {raise = true})
                end
            end
        },
        launcher = {
            ['open a terminal'] = function()
                awful.spawn(applications.terminal)
            end,
            ['run prompt'] = function()
                awful.screen.focused().promptbox:run()
            end,
            ['show the menubar'] = function() menubar.show() end
        },
        layout = {
            ['decrease master width factor'] = function()
                awful.tag.incmwfact(-0.05)
            end,
            ['decrease the number of columns'] = function()
                awful.tag.incncol(-1, nil, true)
            end,
            ['decrease the number of master clients'] = function()
                awful.tag.incnmaster(-1, nil, true)
            end,
            ['increase master width factor'] = function()
                awful.tag.incmwfact(0.05)
            end,
            ['increase the number of columns'] = function()
                awful.tag.incncol(1, nil, true)
            end,
            ['increase the number of master clients'] = function()
                awful.tag.incnmaster(1, nil, true)
            end,
            ['select next'] = function() awful.layout.inc(1) end,
            ['select previous'] = function() awful.layout.inc(-1) end
        },
        screen = {
            ['focus the next screen'] = function()
                awful.screen.focus_relative(1)
            end,
            ['focus the previous screen'] = function()
                awful.screen.focus_relative(-1)
            end
        },
        tag = {
            ['go back'] = awful.tag.history.restore,
            ['view next'] = awful.tag.viewnext,
            ['view previous'] = awful.tag.viewprev
        }
    }

    actions.client = {
        client = {
            ['(un)maximize'] = function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            ['(un)maximize vertically'] = function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            ['(un)maximize horizontally'] = function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            ['close'] = function(c) c:kill() end,
            ['minimize'] = function(c) c.minimized = true end,
            ['move to master'] = function(c)
                c:swap(awful.client.getmaster())
            end,
            ['move to screen'] = function(c)
                c:move_to_screen()
                c:emit_signal('manage', 'key.movetoscreen', {})
                c:emit_signal('request::activate', 'key.movetoscreen',
                              {raise = true})
            end,
            ['toggle floating'] = function(c)
                if c.fullscreen then return end
                awful.client.floating.toggle(c)
            end,
            ['toggle fullscreen'] = function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            ['toggle keep on top'] = function(c)
                c.ontop = not c.ontop
            end

        }
    }
    return actions
end

-- [ return module ] -----------------------------------------------------------
return module
