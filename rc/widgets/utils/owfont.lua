-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : owfont.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:03 (Marcel Arpogaus)
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
local awful = require('awful')
local gears = require('gears')

local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- [ local objects ] -----------------------------------------------------------
local common = {
    -- Thunderstorm ------------------------------------------------------------
    ['thunderstorm with light rain'] = '&#60200;',
    ['thunderstorm with rain'] = '&#60201;',
    ['thunderstorm with heavy rain'] = '&#60202;',
    ['light thunderstorm'] = '&#60210;',
    ['thunderstorm'] = '&#60211;',
    ['heavy thunderstorm'] = '&#60212;',
    ['ragged thunderstorm'] = '&#60221;',
    ['thunderstorm with light drizzle'] = '&#60230;',
    ['thunderstorm with drizzle'] = '&#60231;',
    ['thunderstorm with heavy drizzle'] = '&#60232;',

    -- Drizzle -----------------------------------------------------------------
    ['light intensity drizzle'] = '&#60300;',
    ['drizzle'] = '&#60301;',
    ['heavy intensity drizzle'] = '&#60302;',
    ['light intensity drizzle rain'] = '&#60310;',
    ['drizzle rain'] = '&#60311;',
    ['heavy intensity drizzle rain'] = '&#60312;',
    ['shower rain and drizzle'] = '&#60313;',
    ['heavy shower rain and'] = '&#60314;',
    ['shower drizzle'] = '&#60321;',

    -- Rain --------------------------------------------------------------------
    ['light rain'] = '&#60500;',
    ['moderate rain'] = '&#60501;',
    ['heavy intensity rain'] = '&#60502;',
    ['very heavy rain'] = '&#60503;',
    ['extreme rain'] = '&#60504;',
    ['freezing rain'] = '&#60511;',
    ['light intensity shower rain'] = '&#60520;',
    ['shower rain'] = '&#60521;',
    ['heavy intensity shower rain'] = '&#60522;',
    ['ragged shower rain'] = '&#60531;',

    -- Snow --------------------------------------------------------------------
    ['light snow'] = '&#60600;',
    ['snow'] = '&#60601;',
    ['heavy snow'] = '&#60602;',
    ['sleet'] = '&#60611;',
    ['shower sleet'] = '&#60612;',
    ['light rain and snow'] = '&#60615;',
    ['rain and snow'] = '&#60616;',
    ['light shower snow'] = '&#60620;',
    ['shower snow'] = '&#60621;',
    ['heavy shower snow'] = '&#60622;',

    -- Atmosphere --------------------------------------------------------------
    ['mist'] = '&#60701;',
    ['smoke'] = '&#60711;',
    ['haze'] = '&#60721;',
    ['sand/dust whirls'] = '&#60731;',
    ['fog'] = '&#60741;',
    ['sand'] = '&#60751;',
    ['dust'] = '&#60761;',
    ['volcanic ash'] = '&#60762;',
    ['squalls'] = '&#60771;',

    -- Clouds ------------------------------------------------------------------
    -- ["sky is clear night"] = "&#61800;",
    -- ["sky is clear"] = "&#60800;",

    -- ["calm"] = "&#60800;",
    -- ["calm night"] = "&#61800;",

    -- ["few clouds"] = "&#60801;",
    -- ["few clouds night"] = "&#61801;",

    -- ["scattered clouds"] = "&#60802;",
    -- ["scattered clouds night"] = "&#61802;",

    ['broken clouds'] = '&#60803;',
    ['overcast clouds'] = '&#60804;',

    -- Extreme -----------------------------------------------------------------
    ['tornado'] = '&#60900;',
    ['tropical storm'] = '&#60901;',
    ['hurricane'] = '&#60902;',
    ['cold'] = '&#60903;',
    ['hot'] = '&#60904;',
    ['windy'] = '&#60905;',
    ['hail'] = '&#60906;',

    -- Additional --------------------------------------------------------------
    ['setting'] = '&#60950;',
    ['light breeze'] = '&#60952;',
    ['gentle breeze'] = '&#60953;',
    ['moderate breeze'] = '&#60954;',
    ['fresh breeze'] = '&#60955;',
    ['strong  breeze'] = '&#60956;',
    ['high wind, near gale'] = '&#60957;',
    ['gale'] = '&#60958;',
    ['severe gale'] = '&#60959;',
    ['storm'] = '&#60960;',
    ['violent storm'] = '&#60961;'
}

local module = {
    day = my_table.join(common, {
        ['clear sky'] = '&#60800;',
        ['calm'] = '&#60800;',
        ['few clouds'] = '&#60801;',
        ['scattered clouds'] = '&#60802;'
    }),
    night = my_table.join(common, {
        ['clear sky'] = '&#61800;',
        ['calm'] = '&#61800;',
        ['few clouds'] = '&#61801;',
        ['scattered clouds'] = '&#61802;'
    })
}

-- [ return module ] -----------------------------------------------------------
return module
