-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : abstract_element.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 11:32:32 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local gears = require('gears')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.new = function(def)
    local element = {}
    element.unregister = function(s)
        if not s.unregister_elements[element] then
            gears.debug.print_warning(
                'cant unregister: element not registered on this screen.'
            )
        else
            def.unregister_fn(s)
            s.unregister_elements[element] = nil
        end
    end
    element.register = function(s)
        if not s.unregister_elements then
            error('screen initialized: call screen.init() first')
        else
            if s.unregister_elements[element] then
                gears.debug.print_warning(

                   
                        'cant register: element is already registered on this screen.'
                )
            else
                s.unregister_elements[element] = element.unregister
                def.register_fn(s)
            end
        end
    end
    element.update = function(s)
        if def.update_fn then
            def.update_fn(s)
        else
            gears.debug.print_warning('no update_fn provided')
        end
    end
    return element
end

-- [ return module ] -----------------------------------------------------------
return module
