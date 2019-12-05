--------------------------------------------------------------------------------
-- @File:   helper_functions.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-12-05 19:01:59
-- @Changes: 
-- 		- new helper functions to switch colorscheme
-- @Last Modified by:   marcel
-- @Last Modified time: 2019-12-03 15:15:04
-- @Changes: 
--    - newly written
--------------------------------------------------------------------------------

-- [ module imports ] ----------------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")

-- [ global functions ] --------------------------------------------------------
local function set_wpg_colorscheme( theme )
  awful.spawn.with_shell(string.format("wpg -s %s.png", theme))
end
local function set_subl_colorscheme( theme )
  local subl_prefs = string.format("%s/.config/sublime-text-3/Packages/User/Preferences.sublime-settings", os.getenv("HOME"))
  awful.spawn.with_shell(string.format("sed -i 's:ayu-\\(light\\|dark\\|mirage\\):ayu-%s:' '%s'", theme, subl_prefs))
end
local function set_icon_colorscheme( theme )
  local xsettings_conf = string.format("%s/.config/awesome/xsettings", os.getenv("HOME"), chosen_theme)
  if theme then
    awful.spawn.with_shell(string.format("echo 'Net/IconThemeName \"%s\"\n' > %s && xsettingsd -c %s", theme, xsettings_conf, xsettings_conf))
  else
    awful.spawn.with_shell(string.format("xsettingsd -c %s", xsettings_conf))
  end
end
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end
local function set_color_scheme(cs,ico)
    local theme = beautiful.get()
    theme["set_" .. cs](theme)
    -- update awesome colorscheme 
    awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
    -- update gtk/rofi colorscheme
    set_wpg_colorscheme(cs)
    -- update sublime colorscheme
    set_subl_colorscheme(cs)
    -- update icon theme
    set_icon_colorscheme(ico)
end
function set_dark()
    set_color_scheme("dark", "flattrcolor")
end
function set_mirage()
    set_color_scheme("mirage", "flattrcolor")
end
function set_light()
    set_color_scheme("light", "flattrcolor-dark")
end