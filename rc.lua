-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rc.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:54 (Marcel Arpogaus)
-- @Changed: 2021-01-26 17:18:28 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- This file is part of my modular awesome WM configuration.
-- [ license ] -----------------------------------------------------------------
-- Copyright (C) 2021 Marcel Arpogaus
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local os = os

-- Standard awesome library
local awful = require('awful')

-- rc modules
local error_handling = require('rc.error_handling')
local elements = require("rc.elements")
local assets = require("rc.assets")
local key_bindings = require('rc.key_bindings')
local layouts = require('rc.layouts')
local menu = require('rc.menu')
local mouse_bindings = require('rc.mouse_bindings')
local rules = require('rc.rules')
local screen = require('rc.screen')
local signals = require('rc.signals')
local tags = require('rc.tags')
local themes = require("rc.themes")
local utils = require('rc.utils')

-- Mac OSX like 'Expose' view of all clients.
local revelation = require('revelation')

-- configuration file
local config = utils.load_config()

-- ensure that there's always a client that has focus
require('awful.autofocus')

-- [ initialization ] ----------------------------------------------------------
-- error handling
error_handling.init()

-- connect signals
signals.init()

-- tags
tags.init(config)

-- layouts
layouts.init(config)

-- theme
themes.init(config)

-- assets
assets.init(config)

-- wibars and widgest
elements.init(config)

-- menues
menu.init(config)

-- mouse bindings
mouse_bindings.init(config, menu.mainmenu)

-- key bindings
key_bindings.init(config, menu.mainmenu)

-- rules
rules.init(config, mouse_bindings.client_buttons, key_bindings.client_keys)

-- wibars and widgets
screen.init(
    config, tags.tagnames, mouse_bindings.taglist_buttons,
    mouse_bindings.tasklist_buttons, menu.mainmenu, menu.exitmenu
)
screen.register(elements.wibar)
if elements.desktop then
  screen.register(elements.desktop)
end

-- Initialize revelation
revelation.init()

-- [ autorun programs ] --------------------------------------------------------
awful.spawn.with_shell('~/.config/awesome/autorun.sh')
