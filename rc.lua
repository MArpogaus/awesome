-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rc.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:54 (Marcel Arpogaus)
-- @Changed: 2021-09-29 09:38:36 (Marcel Arpogaus)
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
-- helper functions
local utils = require('rc.utils')

-- rc modules
local assets = require('rc.assets')
local behavior = require('rc.behavior')
local decorations = require('rc.decorations')
local error_handling = require('rc.error_handling')
local key_bindings = require('rc.key_bindings')
local layouts = require('rc.layouts')
local mouse_bindings = require('rc.mouse_bindings')
local screen = require('rc.screen')
local tags = require('rc.tags')
local theme = require('rc.theme')
local session = require('rc.session')

-- configuration file
local config = utils.load_config()

-- Mac OSX like 'Expose' view of all clients.
local revelation = require('revelation')

-- ensure that there's always a client that has focus
require('awful.autofocus')

-- [ initialization ] ----------------------------------------------------------
-- Initialize error handling
error_handling.init()

-- Initialize the session
session.init(config.session, function()
    -- Initialize tags
    tags.init(config.tagnames)

    -- Initialize layouts
    layouts.init(config.layouts)

    -- Initialize theme
    theme.init(config.theme)

    -- Initialize assets
    assets.init(config.assets)

    -- Initialize wibars and widgest
    decorations.init(config.decorations)

    -- Initialize mouse bindings
    mouse_bindings.init(config.bindings)

    -- Initialize key bindings
    key_bindings.init(config.bindings, config.applications)

    -- Initialize Screens
    screen.init(config.screen, tags.tagnames)
    for _, d in ipairs(decorations.get()) do screen.register(d) end

    -- Initialize behavior
    behavior.init(config.behavior, mouse_bindings.client_buttons,
                  key_bindings.client_keys)

    -- Initialize revelation
    revelation.init()
end)
