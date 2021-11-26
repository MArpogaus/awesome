-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:02:46 (Marcel Arpogaus)
-- @Changed: 2021-10-18 16:40:40 (Marcel Arpogaus)
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

-- Standard awesome library
local awful = require('awful')

-- Theme handling library
local beautiful = require('beautiful')

-- helper function
local utils = require('utils')

-- screen module
local screen = require('screen')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {titlebar = {style = 'default'}}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    config = utils.deep_merge(module.defaults, config, 1)
    return {
        -- Signal function to execute when a new client appears.
        client = {
            ['manage'] = function(c)
                -- Set the windows at the slave,
                -- i.e. put it at the end of others instead of setting it master.
                -- if not awesome.startup then awful.client.setslave(c) end

                if capi.awesome.startup and not c.size_hints.user_position and
                    not c.size_hints.program_position then
                    -- Prevent clients from being unreachable after screen count changes.
                    awful.placement.no_offscreen(c)
                end
            end,
            -- Add a titlebar if titlebars_enabled is set to true in the rules.
            ['request::titlebars'] = function(c)
                require('behavior.default.titlebars.' .. config.titlebar.style).init(
                    c, config.titlebar)
            end,
            -- Enable sloppy focus, so that focus follows mouse.
            ['mouse::enter'] = function(c)
                if awful.layout.get(c.screen).name ~= 'magnifier' then
                    c:emit_signal('request::activate', 'mouse_enter',
                                  {raise = false})

                end
                if c.screen.systray_set_screen then
                    c.screen.systray_set_screen()
                end
            end,

            ['focus'] = function(c)
                c.border_color = beautiful.border_focus
            end,
            ['unfocus'] = function(c)
                c.border_color = beautiful.border_normal
            end
        },
        -- signal handlers for screens
        screen = {
            -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
            ['property::geometry'] = screen.update,
            ['removed'] = screen.remove
        }
    }

end

-- [ return module ] -----------------------------------------------------------
return module
