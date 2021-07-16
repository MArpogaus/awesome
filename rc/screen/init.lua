-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local capi = {client = client, screen = screen}

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local menubar = require('menubar')

local tasklist = require('rc.screen.tasklist')
local layout_popup = require('rc.screen.layout_popup')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local update_screen

-- [ module functions ] --------------------------------------------------------
module.init = function(
    config, tagnames, taglist_buttons, tasklist_buttons, mainmenu, exitmenu
)
    awful.screen.set_auto_dpi_enabled(config.auto_dpi)
    update_screen = function(s)

        -- Each screen has its own tag table.
        awful.tag(tagnames, s,
                  awful.layout.default[s.index] or awful.layout.layouts[1])

        s.init = function()
            -- prevent multiple runs
            if s.taglist then return end

            if config.dpi then s.dpi = config.dpi end

            -- If wallpaper is a function, call it with the screen
            local wallpaper = config.wallpaper or beautiful.wallpaper
            if type(wallpaper) == 'function' then
                gears.wallpaper.maximized(wallpaper(s), s, true)
            elseif wallpaper == 'xfconf-query' then
                local command =
                    'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path'
                awful.spawn.easy_async_with_shell(command,
                                                  function(
                    stdout, _, _, exit_code
                )
                    if exit_code == 0 then
                        local file_name = string.gsub(stdout, '\n', '')
                        gears.wallpaper.maximized(file_name, s, true)
                    else
                        gears.wallpaper.maximized(beautiful.wallpaper(s), s,
                                                  true)
                    end
                end)
            else
                gears.wallpaper.maximized(wallpaper, s, true)
            end

            -- Create a promptbox for each screen
            s.promptbox = awful.widget.prompt()

            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            -- We need one layoutbox per screen.
            s.layoutbox = awful.widget.layoutbox(s)
            s.layout_popup = layout_popup.init(s.layoutbox)
            s.layoutbox:buttons(gears.table.join(
                awful.button({}, 4, function()
                    awful.layout.inc(1)
                end), awful.button({}, 5, function()
                    awful.layout.inc(-1)
                end)))

            -- Create a taglist widget
            s.taglist = awful.widget.taglist {
                screen = s,
                filter = awful.widget.taglist.filter.all,
                buttons = taglist_buttons
            }

            -- Create a tasklist widget
            s.tasklist = tasklist[config.tasklist](s, tasklist_buttons)

            -- menus
            if config.mainmenu then
                s.mainmenu = awful.widget.launcher(
                    {image = beautiful.awesome_icon, menu = mainmenu})
            end
            if config.exitmenu then
                s.exitmenu = awful.widget.launcher(
                    {
                        image = beautiful.exitmenu_icon or
                            menubar.utils.lookup_icon('system-shutdown'),
                        menu = exitmenu
                    })
            end
        end

        -- Dynamic widget management
        s.decorations = {}

        s.update_decorations = function()
            for e, _ in pairs(s.decorations) do e.update(s) end
        end
        s.unregister_decorations = function()
            for e, _ in pairs(s.decorations) do e.unregister(s) end
        end
        s.reregister_decorations = function()
            for e, _ in pairs(s.decorations) do
                e.unregister(s)
                e.register(s)
                e.update(s)
            end
        end

        s.reset = function(soft)

            if s.layout_popup then
                layout_popup.reset(s.layout_popup, s.layoutbox)
                s.layout_popup = nil
            end
            if s.layoutbox then
                s.layoutbox:reset()
                s.layoutbox:remove()
                s.layoutbox = nil
            end
            if s.promptbox then
                -- s.promptbox:reset()
                -- s.promptbox:remove()
                s.promptbox = nil
            end
            if s.taglist then
                s.taglist:reset()
                s.taglist:remove()
                s.taglist = nil
            end

            if not soft then s.unregister_decorations() end
            collectgarbage()
        end

        s.move_all_clients = function()
            for _, c in pairs(s:get_all_clients()) do
                c:move_to_screen()
                c:emit_signal('manage', 'screen', {})
            end
        end

        s:connect_signal('removed', s.reset)
        s:connect_signal('removed', s.move_all_clients)
        s.init()
    end
    awful.screen.connect_for_each_screen(update_screen)
end
module.register = function(decoration)
    awful.screen.connect_for_each_screen(decoration.register)
end
module.unregister = function(decoration)
    awful.screen.disconnect_for_each_screen(decoration.register)
    for s in capi.screen do decoration.unregister(s) end
end
module.update = function()
    for s in capi.screen do
        s.reset(true)
        s.init()
        s.reregister_decorations()
    end
end
-- [ return module ] -----------------------------------------------------------
return module
