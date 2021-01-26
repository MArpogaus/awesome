--------------------------------------------------------------------------------
-- @File:   error_handling.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-04 16:48:36
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
-- grab environment
local capi = {awesome = awesome}

-- Notification library
local naughty = require('naughty')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ sequential code ] ---------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if capi.awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = 'Oops, there were errors during startup!',
            text = capi.awesome.startup_errors
        }
    )
end

-- [ module functions ] --------------------------------------------------------
module.init = function()
    -- Handle runtime errors after startup
    local in_error = false
    capi.awesome.connect_signal(
        'debug::error', function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true
            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = 'Oops, an error happened!',
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- [ return module ] -----------------------------------------------------------
return module
