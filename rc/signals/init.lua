-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:53:38 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {awesome = awesome, client = client, screen = screen, tag = tag}

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
module.init = function()
    -- Signal function to execute when a new client appears.
    capi.client.connect_signal(
        'manage', function(c)
            if capi.awesome.startup and not c.size_hints.user_position and
                not c.size_hints.program_position then
                -- Prevent clients from being unreachable after screen count changes.
                awful.placement.no_offscreen(c)
            end
        end
    )

    -- Add a titlebar if titlebars_enabled is set to true in the rules.
    capi.client.connect_signal(
        'request::titlebars', function(c)
            if c.requests_no_titlebar then
                return
            end
            -- buttons for the titlebar
            local buttons = gears.table.join(
                awful.button(
                    {}, 1, function()
                        c:emit_signal(
                            'request::activate', 'titlebar', {raise = true}
                        )
                        awful.mouse.client.move(c)
                    end
                ), awful.button(
                    {}, 3, function()
                        c:emit_signal(
                            'request::activate', 'titlebar', {raise = true}
                        )
                        awful.mouse.client.resize(c)
                    end
                )
            )

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
                    awful.titlebar.widget.stickybutton(c),
                    awful.titlebar.widget.ontopbutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.minimizebutton(c),
                    awful.titlebar.widget.closebutton(c),
                    layout = wibox.layout.fixed.horizontal()
                },
                layout = wibox.layout.align.horizontal
            }
        end
    )

    -- Enable sloppy focus, so that focus follows mouse.
    capi.client.connect_signal(
        'mouse::enter', function(c)
            if awful.layout.get(c.screen).name ~= 'magnifier' then
                c:emit_signal(
                    'request::activate', 'mouse_enter', {raise = false}
                )
            end

            local focused_screen = awful.screen.focused()
            if not capi.awesome.startup and focused_screen.systray then
                focused_screen.systray:set_screen(focused_screen)
            end
        end
    )

    capi.client.connect_signal(
        'focus', function(c)
            c.border_color = beautiful.border_focus
        end
    )
    capi.client.connect_signal(
        'unfocus', function(c)
            c.border_color = beautiful.border_normal
        end
    )
    capi.client.connect_signal(
        'property::screen', function()
            local focused_screen = awful.screen.focused()
            if not capi.awesome.startup and focused_screen.systray then
                focused_screen.systray:set_screen(focused_screen)
            end
        end
    )

    -- Disable borders on lone windows
    -- Handle border sizes of clients.
    for s = 1, capi.screen.count() do
        capi.screen[s]:connect_signal(
            'arrange', function()
                local clients = awful.client.visible(s)
                local layout = awful.layout.getname(awful.layout.get(s))

                for _, c in pairs(clients) do
                    -- No borders with only one humanly visible client
                    if c.maximized then
                        -- NOTE: also handled in focus, but that does not cover maximizing from a
                        -- tiled state (when the client had focus).
                        c.border_width = 0
                    elseif c.floating or layout == 'floating' then
                        c.border_width = beautiful.border_width
                    elseif layout == 'max' or layout == 'fullscreen' then
                        c.border_width = 0
                    else
                        local tiled = awful.client.tiled(c.screen)
                        if #tiled == 1 then -- and c == tiled[1] then
                            tiled[1].border_width = 0
                            -- if layout ~= "max" and layout ~= "fullscreen" then
                            -- XXX: SLOW!
                            -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
                            -- end
                        else
                            c.border_width = beautiful.border_width
                        end
                    end
                end
            end
        )
    end
    capi.client.connect_signal(
        'property::floating', function(c)
            if c.floating and not c.requests_no_titlebars then
                awful.titlebar.show(c)
            else
                awful.titlebar.hide(c)
            end
        end
    )
    capi.tag.connect_signal(
        'property::layout', function(t)
            for _, c in pairs(t:clients()) do
                if t.layout.name == 'floating' and not c.requests_no_titlebars then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            end
        end
    )
end

-- [ return module ] -----------------------------------------------------------
return module
