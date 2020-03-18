--------------------------------------------------------------------------------
-- @File:   menu.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-03-18 13:13:49
-- @Changes: 
-- 		- newly written
-- 		- ...
--------------------------------------------------------------------------------

-- [ module imports ] ----------------------------------------------------------
-- Standard awesome library
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Freedesktop menu
local freedesktop = require("freedesktop")

-- [ local objects ] -----------------------------------------------------------
local module = {}

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
    { "manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
    { "edit config", gui_editor .. " " .. awesome.conffile,  menubar.utils.lookup_icon("accessories-text-editor") },
    { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
local myexitmenu = {
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "lock screen", lock_command, menubar.utils.lookup_icon("system-lock-screen") },
    { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}

-- [ local functions ] ---------------------------------------------------------
local function_name = function ( ... )
    -- body
end

-- [ module objects ] ----------------------------------------------------------
module.var = {}

-- Create a launcher widget and a main menu
module.mainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})
module.exitmenu = awful.widget.launcher({
	image = beautiful.exitmenu_icon,
    menu = awful.menu({
       icon_size = 32,
       items = myexitmenu}
    )
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- [ return module ] -----------------------------------------------------------
return module
