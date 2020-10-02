--------------------------------------------------------------------------------
-- @File:   helper_functions.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-02 14:33:48
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
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
        -- This is used later as the default terminal and editor to run.
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

-- [ return module ]------------------------------------------------------------
return module
