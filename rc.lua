--------------------------------------------------------------------------------
-- @File:   rc.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-12-03 15:34:44
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 11:56:37
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local root = root

-- Standard awesome library
local awful = require('awful')

-- Theme handling library
local beautiful = require('beautiful')

-- Mac OSX like 'Expose' view of all clients.
local revelation = require('revelation')

-- helper functions
local helpers = require('rc.helper_functions')

-- configuration
local config = helpers.load_config()

-- ensure that there's always a client that has focus
require('awful.autofocus')

-- error handling
require('rc.error_handling')

-- connect signals
require('rc.signals')

-- [ theme ] -------------------------------------------------------------------
beautiful.init(
    string.format(
        '%s/.config/awesome/themes/%s/theme.lua', os.getenv('HOME'),
        config.theme
    )
)
beautiful.icon_theme = 'Papirus'

-- [ autorun programs ] --------------------------------------------------------
awful.spawn.with_shell('~/.config/awesome/autorun.sh')

-- Initialize revelation
revelation.init()

-- [ tags ] --------------------------------------------------------------------
require('rc.tags')
--------------------------------------------------------------------------------

-- [ menu ] --------------------------------------------------------------------
local menu = require('rc.menu')
-- add exit menu to wibar
awful.util.myexitmenu = menu.exitmenu
--------------------------------------------------------------------------------

-- [ mouse bindings ] ----------------------------------------------------------
local buttons = require('rc.mouse_bindings')
awful.util.taglist_buttons = buttons.taglist_buttons
awful.util.tasklist_buttons = buttons.tasklist_buttons
root.buttons(buttons.root)
--------------------------------------------------------------------------------

-- [ key bindings ] ------------------------------------------------------------
local keys = require('rc.key_bindings')
root.keys(keys.global_keys)
--------------------------------------------------------------------------------

-- [ setup wibar and desktop widgets ] -----------------------------------------
awful.screen.set_auto_dpi_enabled(true)
awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
--------------------------------------------------------------------------------

-- [ rules ] -------------------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require('rc.rules').rules
--------------------------------------------------------------------------------
