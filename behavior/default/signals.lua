-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:02:46 (Marcel Arpogaus)
-- @Changed: 2021-10-14 20:23:12 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
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
    config = utils.deep_merge(module.defaults, config)
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
