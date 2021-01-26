--------------------------------------------------------------------------------
-- @File:   rc.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-12-03 15:34:44
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-04 16:47:43
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
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
