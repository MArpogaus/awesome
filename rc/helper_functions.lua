--------------------------------------------------------------------------------
-- @File:   helper_functions.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   marcel
-- @Last Modified time: 2019-12-03 15:15:04
-- @Changes: 
-- 		- newly written
-- 		- ...
--------------------------------------------------------------------------------

-- [ module imports ] ----------------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")

-- [ global functions ] --------------------------------------------------------
function wpg( theme )
  awful.spawn.with_shell(string.format("wpg -s %s.png", theme))
end

function subl( theme )
  local subl_prefs = string.format("%s/.config/sublime-text-3/Packages/User/Preferences.sublime-settings", os.getenv("HOME"))
  awful.spawn.with_shell(string.format("sed -i 's:ayu-\\(light\\|dark\\|mirage\\):ayu-%s:' '%s'", theme, subl_prefs))
end

function set_cs(cs) 
    print("setting"..cs.."colorscheme")
    local theme = beautiful.get()
    theme["set_" .. cs](theme)
    -- update awesome colorscheme 
    awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
    -- update gtk/rofi colorscheme
    wpg(cs)
    -- update sublime colorscheme
    subl(cs)
end