-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local table = table

local capi = {client = client, screen = screen}

local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.utils')
local tasklist = require('rc.screen.tasklist')

-- custom wibox widgets
local wibar_widgets = require('rc.widgets.wibar')
local desktop_widgets = require('rc.widgets.desktop')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config,
    tagnames,
    taglist_buttons,
    tasklist_buttons,
    mainmenu,
    exitmenu)
    awful.screen.set_auto_dpi_enabled(config.auto_dpi or true)
    awful.screen.connect_for_each_screen(
        function(s)
            -- Each screen has its own tag table.
            if not s.mytaglist then
                awful.tag(
                    tagnames, s,
                    awful.layout.default[s.index] or awful.layout.layouts[1]
                )
            end

            if s.reset then s.reset() end

            if config.dpi then s.dpi = config.dpi end

            -- If wallpaper is a function, call it with the screen
            local wallpaper = config.wallpaper or beautiful.wallpaper
            if type(wallpaper) == 'function' then
                gears.wallpaper.maximized(wallpaper(s), s, true)
            elseif wallpaper == 'xfconf-query' then
                local command =
                    'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path'
                awful.spawn.easy_async_with_shell(
                    command,
                    function(stdout, stderr, reason, exit_code) -- luacheck: no unused args
                        if exit_code == 0 then
                            local file_name = string.gsub(stdout, '\n', '')
                            gears.wallpaper.maximized(file_name, s, true)
                        else
                            gears.wallpaper.maximized(
                                beautiful.wallpaper(s), s, true
                            )
                        end
                    end
                )
            else
                gears.wallpaper.maximized(wallpaper, s, true)
            end

            -- Create a promptbox for each screen
            s.mypromptbox = awful.widget.prompt()

            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            -- We need one layoutbox per screen.
            s.mylayoutbox = awful.widget.layoutbox(s)
            s.mylayoutbox:buttons(
                -- TODO: Add to mous bindigs
                gears.table.join(
                    awful.button(
                        {}, 1, function()
                            awful.layout.inc(1)
                        end
                    ), awful.button(
                        {}, 3, function()
                            awful.layout.inc(-1)
                        end
                    ), awful.button(
                        {}, 4, function()
                            awful.layout.inc(1)
                        end
                    ), awful.button(
                        {}, 5, function()
                            awful.layout.inc(-1)
                        end
                    )
                )
            )

            -- Create a taglist widget
            s.mytaglist = awful.widget.taglist {
                screen = s,
                filter = awful.widget.taglist.filter.all,
                buttons = taglist_buttons
            }

            -- Create a tasklist widget
            s.mytasklist = tasklist[config.tasklist or beautiful.tasklist or
                               'default'](s, tasklist_buttons)

            -- menus
            s.mymainmenu = mainmenu
            s.myexitmenu = exitmenu

            -- Dynamic widget management
            s.unregister_elements = {}

            -- show systray on focused screen
            s.reset = function()
                for _, unregister in pairs(s.unregister_elements) do
                    unregister(s)
                end

                if s.promptbox then
                    s.promptbox:reset()
                    s.promptbox:remove()
                    s.promptbox = nil
                end
                if s.mytaglist then
                    s.mytaglist:reset()
                    s.mytaglist:remove()
                    s.mytaglist = nil
                end
                collectgarbage()
            end

            s:connect_signal('removed', s.reset)
        end
    )
end
module.register = function(element)
    awful.screen.connect_for_each_screen(element.register)
end
module.unregister = function(element)
    awful.screen.disconnect_for_each_screen(element.register)
    for s in capi.screen do element.unregister(s) end
end
-- [ return module ] -----------------------------------------------------------
return module
