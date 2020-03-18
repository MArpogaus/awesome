--------------------------------------------------------------------------------
-- @File:   rc.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-12-03 15:34:44
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-03-18 14:22:21
-- @Changes: 
--    - added lock_command
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-12-03 16:06:22
-- @Changes: 
--    - newly written
--------------------------------------------------------------------------------

-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
local lain  = require("lain")
-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Mac OSX like 'Expose' view of all clients.
local revelation = require("revelation")

-- ensure that there's always a client that has focus
require("awful.autofocus")

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- error handling
require("rc.error_handling")

-- helper functions
require("rc.helper_functions")

-- connect signals
require("rc.signals")
--------------------------------------------------------------------------------

-- [ autorun programs ] --------------------------------------------------------
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- [ variable definitions ] ----------------------------------------------------
-- Initialize Theme
local chosen_theme= "ayu"
beautiful.init(
  string.format("%s/.config/awesome/themes/%s/theme.lua",
  os.getenv("HOME"),
  chosen_theme)
)
beautiful.icon_theme = "Papirus"

-- Initialize revelation
revelation.init()

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "subl"
terminal = os.getenv("TERMINAL") or "lxterminal"
lock_command = "light-locker-command -l"

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- Define default layout per screen
awful.layout.default = {
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
}

-- Default names for tags
awful.util.tagnames = { "1", "2", "3", "4", "5", "6" }
--------------------------------------------------------------------------------

-- [ menu ] --------------------------------------------------------------------
local menu = require("rc.menu")
mymainmenu = menu.mainmenu
awful.util.myexitmenu = menu.exitmenu
--------------------------------------------------------------------------------

-- [ mouse bindings ] ----------------------------------------------------------
local buttons = require("rc.mouse_bindings")
awful.util.taglist_buttons = buttons.taglist_buttons
awful.util.tasklist_buttons = buttons.tasklist_buttons
client_buttons = buttons.client_buttons
root.buttons(buttons.root)
--------------------------------------------------------------------------------

-- [ key bindings ] ------------------------------------------------------------
local keys = require("rc.key_bindings")
client_keys = keys.client_keys  
root.keys(keys.global_keys)
--------------------------------------------------------------------------------

-- [ setup wibar and desktop widgets ] -----------------------------------------
awful.screen.set_auto_dpi_enabled(true)
awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
--------------------------------------------------------------------------------

-- [ rules ] -------------------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("rc.rules").rules
--------------------------------------------------------------------------------