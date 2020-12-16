--------------------------------------------------------------------------------
-- @File:   helper_functions.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-08 11:19:24
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local capi = {screen = screen, client = client}

-- Standard awesome library
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local gfs = require('gears.filesystem')

-- [ local variables ] ---------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
-- ref.: https://stackoverflow.com/questions/62286322/grouping-windows-in-the-tasklist
local function client_label(c)
    local theme = beautiful.get()
    local sticky = theme.tasklist_sticky or "▪"
    local ontop = theme.tasklist_ontop or '⌃'
    local above = theme.tasklist_above or '▴'
    local below = theme.tasklist_below or '▾'
    local floating = theme.tasklist_floating or '✈'
    local minimized = theme.tasklist_maximized or '-'
    local maximized = theme.tasklist_maximized or '+'
    local maximized_horizontal = theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = theme.tasklist_maximized_vertical or '⬍'

    local name = c.name
    if c.sticky then name = sticky .. name end

    if c.ontop then
        name = ontop .. name
    elseif c.above then
        name = above .. name
    elseif c.below then
        name = below .. name
    end

    if c.minimized then name = minimized .. name end
    if c.maximized then
        name = maximized .. name
    else
        if c.maximized_horizontal then
            name = maximized_horizontal .. name
        end
        if c.maximized_vertical then name = maximized_vertical .. name end
        if c.floating then name = floating .. name end
    end

    return name
end

-- [ module functions ] --------------------------------------------------------
function module.sleep(n) os.execute('sleep ' .. tonumber(n)) end

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
        altkey = 'Mod1',

        -- Select theme
        theme = 'ayu'

    }
    if gfs.file_readable(gfs.get_configuration_dir() .. 'config.lua') then
        config = gears.table.crush(config, require(config_file or 'config'))
    end
    return config
end

-- Delete the current tag
function module.delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

-- Create a new tag at the end of the list
function module.add_tag()
    awful.prompt.run {
        prompt = 'New tag name: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

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
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then t.name = new_name end
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
    if not t then return end

    local clients = t:clients()
    local t2 = awful.tag.add(t.name, awful.tag.getdata(t))

    t2:clients(clients)
    t2:view_only()
end

function module.move_to_screen(c)
    if not c then return end

    local sc = capi.screen.count()
    local s = c.screen.index + 1
    if s > sc then s = 1 end

    local s1 = awful.screen.focused()
    local s2 = capi.screen[s]

    if s1 == s2 then return end

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
    awful.menu.menu_keys.down = {"Tab", "Down"}
    awful.menu.client_list {
        theme = {width = 1000, height = 64},
        item_args = {keygrabber = true, coords = {x = 0, y = 0}},
        -- TODO: why not working?
        filter = function(c)
            return awful.widget.tasklist.filter.currenttags(c, c.screen)
        end
    }
end
-- [ return module ]------------------------------------------------------------
return module
