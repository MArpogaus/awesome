-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:02:46 (Marcel Arpogaus)
-- @Changed: 2021-07-29 15:25:05 (Marcel Arpogaus)
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

-- screen module
local screen = require('rc.screen')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local titlebar_buttons = config.titlebar_buttons or
                                 {
            'floating',
            'maximized',
            'sticky',
            'ontop',
            'close'
        }
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

                local titlebar_buttons_container =
                    {layout = wibox.layout.fixed.horizontal}
                for _, tb in ipairs(titlebar_buttons) do
                    table.insert(titlebar_buttons_container,
                                 awful.titlebar.widget[tb .. 'button'](c))
                end

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
                    -- Right
                    titlebar_buttons_container,
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
