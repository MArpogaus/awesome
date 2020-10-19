--------------------------------------------------------------------------------
-- @File:   helper_functions.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-19 22:24:57
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
-- Standard awesome library
local awful = require('awful')
local gears = require('gears')
local gfs = require('gears.filesystem')

-- [ local variables ] ---------------------------------------------------------
local module = {}

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

    local sc = screen.count()
    local s = c.screen.index + 1
    if s > sc then s = 1 end

    local s1 = awful.screen.focused()
    local s2 = screen[s]

    if s1 == s2 then return end

    local t1 = s1.selected_tag

    local t2 = awful.tag.find_by_name(s2, t1.name)
    if t2 == nil then
        local td = awful.tag.getdata(t1)
        t2 = awful.tag.add(t1.name, td, {screen = s2})
        t2.instances[s] = t2
    end

    c:move_to_screen()
    c:move_to_tag(t2)
    t2:view_only()
end

-- [ return module ]------------------------------------------------------------
return module
