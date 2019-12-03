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


require("awful.autofocus")

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
require("rc.error_handling")
-- }}}

-- {{{ Helper functions
require("rc.helper_functions")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
local chosen_theme= "ayu"
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- beautiful.init("/usr/share/awesome/themes/cesious/theme.lua")
beautiful.icon_theme        = "Papirus"
-- beautiful.bg_normal         = "#222D32"
-- beautiful.bg_focus          = "#2C3940"
-- beautiful.titlebar_close_button_normal = "/usr/share/awesome/themes/cesious/titlebar/close_normal_adapta.png"
-- beautiful.titlebar_close_button_focus = "/usr/share/awesome/themes/cesious/titlebar/close_focus_adapta.png"
-- beautiful.font              = "Noto Sans Regular 10"
-- beautiful.notification_font = "Noto Sans Bold 14"

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "mousepad"
terminal = os.getenv("TERMINAL") or "lxterminal"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
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
awful.layout.default = {
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
}
awful.util.tagnames = { "1", "2", "3", "4", "5", "6" }
-- }}}

-- {{{ Menu
local menu = require("rc.menu")
mymainmenu = menu.mainmenu
awful.util.myexitmenu = menu.exitmenu
-- }}}

-- {{{ Mouse bindings
local buttons = require("rc.mouse_bindings")
awful.util.taglist_buttons = buttons.taglist_buttons
awful.util.tasklist_buttons = buttons.tasklist_buttons
client_buttons = buttons.client_buttons
root.buttons(buttons.root)
-- }}}

-- {{{ Setup wibar and desktop widgets
awful.screen.set_auto_dpi_enabled(true)
awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
-- }}}

-- {{{ Key bindings
local keys = require("rc.key_bindings")
client_keys = keys.client_keys  
root.keys(keys.global_keys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("rc.rules").rules
-- }}}

-- {{{ Signals
require("rc.signals")
-- }}}

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

