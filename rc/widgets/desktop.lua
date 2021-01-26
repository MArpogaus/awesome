-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : desktop.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:47 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
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
local module = {}

-- [ module functions ] --------------------------------------------------------
module.clock = date_time.create_desktop_widget
module.weather = weather.create_desktop_widget

-- [ arcs ] --------------------------------------------------------------------
module.arcs = {
    net_down = function(warg)
        warg.value = 'down'
        return net.create_arc_widget(warg)
    end,
    net_up = function(warg)
        warg.value = 'up'
        return net.create_arc_widget(warg)
    end,
    vol = volume.create_arc_widget,
    mem = memory.create_arc_widget,
    cpu = cpu.create_arc_widget,
    temp = temp.create_arc_widget,
    bat = battery.create_arc_widget,
    fs = fs.create_arc_widget
}

-- [ return module ] -----------------------------------------------------------
return module
