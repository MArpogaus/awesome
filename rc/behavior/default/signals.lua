-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:02:46 (Marcel Arpogaus)
-- @Changed: 2021-02-10 08:21:28 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {awesome = awesome}

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')

-- Widget and layout library
local wibox = require('wibox')

-- Theme handling library
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(_)
    return {
        -- Signal function to execute when a new client appears.
        client = {
            ['untagged'] = function(c) c:emit_signal('manage') end,
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
                -- buttons for the titlebar
                local buttons = gears.table.join(
                    awful.button({}, 1, function()
                        c:emit_signal('request::activate', 'titlebar',
                                      {raise = true})
                        awful.mouse.client.move(c)
                    end), awful.button({}, 3, function()
                        c:emit_signal('request::activate', 'titlebar',
                                      {raise = true})
                        awful.mouse.client.resize(c)
                    end))

                awful.titlebar(c):setup{
                    { -- Left
                        awful.titlebar.widget.iconwidget(c),
                        buttons = buttons,
                        layout = wibox.layout.fixed.horizontal
                    },
                    { -- Middle
                        { -- Title
                            align = 'center',
                            widget = awful.titlebar.widget.titlewidget(c)
                        },
                        buttons = buttons,
                        layout = wibox.layout.flex.horizontal
                    },
                    { -- Right
                        awful.titlebar.widget.floatingbutton(c),
                        awful.titlebar.widget.maximizedbutton(c),
                        awful.titlebar.widget.stickybutton(c),
                        awful.titlebar.widget.ontopbutton(c),
                        awful.titlebar.widget.closebutton(c),
                        layout = wibox.layout.fixed.horizontal()
                    },
                    layout = wibox.layout.align.horizontal
                }
            end,
            -- Enable sloppy focus, so that focus follows mouse.
            ['mouse::enter'] = function(c)
                if awful.layout.get(c.screen).name ~= 'magnifier' then
                    c:emit_signal('request::activate', 'mouse_enter',
                                  {raise = false})
                end
            end,

            ['focus'] = function(c)
                c.border_color = beautiful.border_focus
            end,
            ['unfocus'] = function(c)
                c.border_color = beautiful.border_normal
            end
        }
    }

end

-- [ return module ] -----------------------------------------------------------
return module
