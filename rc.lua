-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rc.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:54 (Marcel Arpogaus)
-- @Changed: 2021-02-03 16:59:30 (Marcel Arpogaus)
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
-- Standard awesome library
local awful = require('awful')
local gears = require('gears')

-- rc modules
local assets = require('rc.assets')
local behavior = require('rc.behavior')
local decorations = require('rc.decorations')
local error_handling = require('rc.error_handling')
local key_bindings = require('rc.key_bindings')
local layouts = require('rc.layouts')
local menu = require('rc.menu')
local mouse_bindings = require('rc.mouse_bindings')
local screen = require('rc.screen')
local tags = require('rc.tags')
local themes = require('rc.themes')

-- Mac OSX like 'Expose' view of all clients.
local revelation = require('revelation')

-- configuration file
local defaults = require('rc.defaults')
local config = gears.table.crush(defaults, require('config'))

-- ensure that there's always a client that has focus
require('awful.autofocus')

-- [ initialization ] ----------------------------------------------------------
-- error handling
error_handling.init()

-- tags
tags.init(config)

-- layouts
layouts.init(config)

-- theme
themes.init(config)

-- assets
assets.init(config)

-- wibars and widgest
decorations.init(config)

-- menues
menu.init(config)

-- mouse bindings
mouse_bindings.init(config, menu.mainmenu)

-- key bindings
key_bindings.init(config, menu.mainmenu)

-- behavior
behavior.init(config, mouse_bindings.client_buttons, key_bindings.client_keys)

-- wibars and widgets
screen.init(config, tags.tagnames, mouse_bindings.taglist_buttons,
            mouse_bindings.tasklist_buttons, menu.mainmenu, menu.exitmenu)
screen.register(decorations.wibar)
if decorations.desktop then screen.register(decorations.desktop) end

-- Initialize revelation
revelation.init()

-- [ autorun programs ] --------------------------------------------------------
awful.spawn.with_shell('~/.config/awesome/autorun.sh')
