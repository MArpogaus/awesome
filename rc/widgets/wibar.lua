-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibar.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:22 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
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
local battery = require('rc.widgets.battery')
local cpu = require('rc.widgets.cpu')
local date_time = require('rc.widgets.date_time')
local fs = require('rc.widgets.fs')
local memory = require('rc.widgets.memory')
local net = require('rc.widgets.net')
local temp = require('rc.widgets.temp')
local volume = require('rc.widgets.volume')
local weather = require('rc.widgets.weather')

-- [ local objects ] -----------------------------------------------------------
local module = {
    weather = weather.create_wibar_widget,
    net_down = function(warg)
        warg.value = 'down'
        return net.create_wibar_widget(warg)
    end,
    net_up = function(warg)
        warg.value = 'up'
        return net.create_wibar_widget(warg)
    end,
    vol = volume.create_wibar_widget,
    mem = memory.create_wibar_widget,
    cpu = cpu.create_wibar_widget,
    temp = temp.create_wibar_widget,
    bat = battery.create_wibar_widget,
    fs = fs.create_wibar_widget,
    datetime = date_time.create_wibar_widget
}

-- [ return module ] -----------------------------------------------------------
return module
