-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local capi = {client = client, screen = screen}

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

local decorations = require('rc.decorations')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local init_screen

-- [ module functions ] --------------------------------------------------------
module.init = function(config, tagnames)

    module.set_wallpaper = function(s)
        local wallpaper = config.wallpaper or beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            gears.wallpaper.maximized(wallpaper(s), s, true)
        elseif wallpaper == 'xfconf-query' then
            local command =
                'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path'
            awful.spawn.easy_async_with_shell(command,
                                              function(stdout,
                _,
                _,
                exit_code)
                if exit_code == 0 then
                    local file_name = string.gsub(stdout, '\n', '')
                    gears.wallpaper.maximized(file_name, s, true)
                else
                    gears.wallpaper.maximized(beautiful.wallpaper(s), s, true)
                end
            end)
        else
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end

    -- Enable the automatic calculation of the screen DPI (experimental).
    awful.screen.set_auto_dpi_enabled(config.auto_dpi)
    init_screen = function(s)
        -- Each screen has its own tag table.
        awful.tag(tagnames, s,
                  awful.layout.default[s.index] or awful.layout.layouts[1])

        s.init = function()
            -- prevent multiple runs
            if s.initialized then return end

            if config.dpi then s.dpi = config.dpi end

            -- set wallpaer
            module.set_wallpaper(s)

            s.initialized = true
        end

        -- Dynamic widget management
        s.decorations = {}

        s.update_decorations = function()
            for e, _ in pairs(s.decorations) do e:update(s) end
        end
        s.unregister_decorations = function()
            for e, _ in pairs(s.decorations) do e:unregister(s) end
        end
        s.toggle_decorations = function()
            for e, _ in pairs(s.decorations) do
                if e.toggle then e.toggle(s) end
            end
        end
        s.toggle_decorations_widgets = function()
            for e, _ in pairs(s.decorations) do
                if e.toggle_widgets then e.toggle_widgets(s) end
            end
        end
        s.reregister_decorations = function()
            s.unregister_decorations()
            for _, d in ipairs(decorations.get()) do d:register(s) end
        end

        s.reset = function()
            s.unregister_decorations()
            s.decorations = nil
            s.init = nil
            s.initialized = nil
            s.move_all_clients = nil
            s.reregister_decorations = nil
            s.unregister_decorations = nil
            s.update_decorations = nil
            s.reset = nil
        end

        s.move_all_clients = function()
            for _, c in pairs(s:get_all_clients()) do
                c:move_to_screen()
                c:emit_signal('manage', 'screen', {})
            end
        end

        s.init()
    end
    awful.screen.connect_for_each_screen(init_screen)

    for _, d in ipairs(decorations.get()) do
        awful.screen.connect_for_each_screen(function(s) d:register(s) end)
    end
end
module.update = function(s)
    s.init()
    s.reregister_decorations()
end
module.remove = function(s)
    s.move_all_clients()
    s.reset()
    collectgarbage()
end
module.update_all = function() for s in capi.screen do module.update(s) end end
-- [ return module ] -----------------------------------------------------------
return module
