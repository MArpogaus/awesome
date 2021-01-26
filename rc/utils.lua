-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : utils.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:31 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local capi = {screen = screen, client = client}

-- Standard awesome library
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local gfs = require('gears.filesystem')

local lgi = require('lgi')
local cairo = lgi.cairo

-- [ local variables ] ---------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
-- ref.: https://stackoverflow.com/questions/62286322/grouping-windows-in-the-tasklist
local function client_label(c)
    local theme = beautiful.get()
    local sticky = theme.tasklist_sticky or '▪'
    local ontop = theme.tasklist_ontop or '⌃'
    local above = theme.tasklist_above or '▴'
    local below = theme.tasklist_below or '▾'
    local floating = theme.tasklist_floating or '✈'
    local minimized = theme.tasklist_maximized or '-'
    local maximized = theme.tasklist_maximized or '+'
    local maximized_horizontal = theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = theme.tasklist_maximized_vertical or '⬍'

    local name = c.name
    if c.sticky then
        name = sticky .. name
    end

    if c.ontop then
        name = ontop .. name
    elseif c.above then
        name = above .. name
    elseif c.below then
        name = below .. name
    end

    if c.minimized then
        name = minimized .. name
    end
    if c.maximized then
        name = maximized .. name
    else
        if c.maximized_horizontal then
            name = maximized_horizontal .. name
        end
        if c.maximized_vertical then
            name = maximized_vertical .. name
        end
        if c.floating then
            name = floating .. name
        end
    end

    return name
end
local function set_xconf(property, value, sleep)
    local xconf = string.format(
        'xfconf-query -c xsettings --property %s --set \'%s\'', property, value
    )
    if sleep then
        xconf = string.format('sleep %.1f && %s', sleep, xconf)
    end
    awful.spawn.with_shell(xconf)
end
local function set_color_scheme(cs, ico)
    error('not implemented')
end

-- [ module functions ] --------------------------------------------------------
function module.sleep(n)
    os.execute('sleep ' .. tonumber(n))
end

-- Helper functions for modifying hex colors -----------------------------------
local hex_color_match = '[a-fA-F0-9][a-fA-F0-9]'
function module.darker(color, ratio)
    local pattern = gears.color(color)
    local kind = pattern:get_type()
    ratio = 1 - ratio / 100
    if kind == 'SOLID' then
        local _, r, g, b, a = pattern:get_rgba()
        r = math.min(math.floor(ratio * r * 0xFF), 0xFF)
        g = math.min(math.floor(ratio * g * 0xFF), 0xFF)
        b = math.min(math.floor(ratio * b * 0xFF), 0xFF)
        a = math.floor(a * 0xFF)
        return string.format('#%02x%02x%02x%02x', r, g, b, a) -- cairo.Pattern.create_rgba(r,g,b,a)
    else
        return color
    end
end
function module.is_dark(color)
    local pattern = gears.color(color)
    local kind = pattern:get_type()

    if kind == 'SOLID' then
        local _, r, g, b, _ = pattern:get_rgba()
        if (r + b + g) > 1.5 then
            return true
        else
            return false
        end
    else
        return
    end
end
function module.reduce_contrast(color, ratio)
    ratio = ratio or 50
    if module.is_dark(color) then
        return module.darker(color, -ratio)
    else
        return module.darker(color, ratio)
    end
end
function module.set_alpha(color, alpha)
    local pattern = gears.color(color)
    local kind = pattern:get_type()

    if kind == 'SOLID' then
        local _, r, g, b, _ = pattern:get_rgba()
        return cairo.Pattern.create_rgba(r, g, b, alpha / 100)
    else
        return color
    end
end

-- Load configuration file
function module.load_config(config_file)
    local config = {
        -- This is used later as the default terminal, editor etc.
        browser = 'exo-open --launch WebBrowser' or 'firefox',
        filemanager = 'exo-open --launch FileManager' or 'thunar',
        gui_editor = 'subl',
        terminal = os.getenv('TERMINAL') or 'lxterminal',
        lock_command = 'light-locker-command -l',

        -- Default modkey.
        modkey = 'Mod4',
        altkey = 'Mod1'
    }
    if gfs.file_readable(gfs.get_configuration_dir() .. 'config.lua') then
        config = gears.table.crush(config, require(config_file or 'config'))
    end
    return config
end

-- Delete the current tag
function module.delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then
        return
    end
    t:delete()
end

-- Create a new tag at the end of the list
function module.add_tag()
    awful.prompt.run {
        prompt = 'New tag name: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then
                return
            end

            awful.tag.add(
                new_name, {
                    screen = awful.screen.focused(),
                    layout = awful.layout.suit.floating
                }
            ):view_only()
        end
    }
end

-- Rename the current tag
function module.rename_tag()
    awful.prompt.run {
        prompt = 'Rename tag: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then
                return
            end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

-- taken from: https://github.com/lcpz/lain/blob/master/util/init.lua
-- Move current tag
-- pos in {-1, 1} <-> {previous, next} tag position
function module.move_tag(pos)
    local tag = awful.screen.focused().selected_tag
    if tonumber(pos) <= -1 then
        awful.tag.move(tag.index - 1, tag)
    else
        awful.tag.move(tag.index + 1, tag)
    end
end

-- taken from: https://github.com/lcpz/lain/blob/master/util/init.lua
-- On the fly useless gaps change
function module.gaps_resize(amount, s, t)
    local scr = s or awful.screen.focused()
    local tag = t or scr.selected_tag
    tag.gap = tag.gap + tonumber(amount)
    awful.layout.arrange(scr)
end

-- taken from: https://github.com/Elv13/tyrannical/blob/master/shortcut.lua
function module.fork_tag()
    local s = awful.screen.focused()
    local t = s.selected_tag
    if not t then
        return
    end

    local clients = t:clients()
    local t2 = awful.tag.add(t.name, awful.tag.getdata(t))

    t2:clients(clients)
    t2:view_only()
end

function module.move_to_screen(c)
    if not c then
        return
    end

    local sc = capi.screen.count()
    local s = c.screen.index + 1
    if s > sc then
        s = 1
    end

    local s1 = awful.screen.focused()
    local s2 = capi.screen[s]

    if s1 == s2 then
        return
    end

    local t1 = s1.selected_tag

    local t2 = awful.tag.find_by_name(s2, t1.name)
    if t2 == nil then
        local td = awful.tag.getdata(t1)
        t2 = awful.tag.add(t1.name, gears.table.clone(td), {screen = s})
        td.instances[s] = t2
    end

    c:move_to_screen()
    c:move_to_tag(t2)
    t2:view_only()
end
function module.client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 1000}})
        end
    end
end

function module.client_stack_toggle_fn()
    local cl_menu
    return function(c)
        if cl_menu then
            cl_menu:hide()
            cl_menu = nil
        else
            local client_num = 0
            local client_list = {}
            for i, cl in ipairs(capi.client.get()) do
                if cl.class == c.class then
                    client_num = client_num + 1
                    client_list[i] = {
                        client_label(cl),
                        function()
                            capi.client.focus = cl
                            cl:tags()[1]:view_only()
                            cl:raise()
                        end,
                        cl.icon
                    }
                end
            end

            if client_num > 1 then
                cl_menu = awful.menu(
                    {items = client_list, theme = {width = 1000}}
                )
                cl_menu:show()
            else
                capi.client.focus = c
                c:tags()[1]:view_only()
                c:raise()
            end
        end
    end
end

function module.application_switcher()
    awful.menu.menu_keys.down = {'Tab', 'Down'}
    awful.menu.client_list {
        theme = {width = 1000, height = 64},
        item_args = {keygrabber = true, coords = {x = 0, y = 0}},
        -- TODO: why not working?
        filter = function(c)
            return awful.widget.tasklist.filter.currenttags(c, c.screen)
        end
    }
end

-- change dpi
function module.inc_dpi(inc)
    for s in capi.screen do
        s.dpi = s.dpi + inc
        set_xconf('/Xft/DPI', math.floor(s.dpi))
    end
end
function module.dec_dpi(dec)
    module.inc_dpi(-dec)
end

-- manage widgets
function module.update_widgets()
    for s in capi.screen do
        s.update_elements()
    end
end
function module.toggle_wibar_widgets()
    for s in capi.screen do
        s.toggle_wibar_widgets()
    end
end
function module.toggle_desktop_widget_visibility()
    for s in capi.screen do
        s.toggle_desktop_widget_visibility()
    end
end

-- change colorschemes
function module.set_dark()
    set_color_scheme('dark', 'flattrcolor')
end
function module.set_mirage()
    set_color_scheme('mirage', 'flattrcolor')
end
function module.set_light()
    set_color_scheme('light', 'flattrcolor-dark')
end

-- [ return module ]------------------------------------------------------------
return module
