-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-25 17:58:40 (Marcel Arpogaus)
-- @Changed: 2021-01-26 16:32:16 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local beautiful = require('beautiful')
local gears = require('gears')
local gmath = require('gears.math')
local cairo = require('lgi').cairo

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local round_button = function(size, fg_color, bg_color, border, border_size)
    border_size = border_size or 1
    local radius = 0.35 * size - border_size

    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)

    -- Create a context
    local cr = cairo.Context(img)

    -- paint transparent bg
    cr:set_source(gears.color('#00000000'))
    cr:paint()

    -- draw border
    if border then
        cr:set_source(gears.color(fg_color or '#00000000'))
        cr:move_to(size / 2 + radius, size / 2)
        cr:arc(size / 2, size / 2, radius + border_size, 0, 2 * math.pi)
        cr:close_path()
        cr:fill()
    end

    -- draw circle
    cr:set_source(gears.color(bg_color))
    cr:move_to(size / 2 + radius, size / 2)
    cr:arc(size / 2, size / 2, radius, 0, 2 * math.pi)
    cr:close_path()
    cr:fill()

    return img, cr
end
local exit_icon = function(size, fg_color, bg_color)
    local img, cr = round_button(size, fg_color, bg_color, true, 2)

    -- draw content
    cr:set_source(gears.color(fg_color))
    local shape_size = 0.4 * size
    local x = (size - shape_size / 4) / 2
    local y = (size - shape_size) / 2
    local shape = gears.shape.transform(gears.shape.rectangle):translate(x, y)
    shape(cr, shape_size / 4, shape_size)
    cr:fill()

    return img
end
local titlebar_button_shapes = {
    close = function(size, fg_color, bg_color, hover)
        local img, cr = round_button(size, fg_color, bg_color, hover)

        -- draw content
        if hover then
            cr:set_source(gears.color(fg_color))
            local shape_size = 0.4 * size
            local thickness = shape_size / 4
            local shape = gears.shape.transform(gears.shape.cross):translate(
                size / 2, size / 2
            ):rotate(math.pi / 4):translate(-shape_size / 2, -shape_size / 2)
            shape(cr, shape_size, shape_size, thickness)
            cr:fill()
        end

        return img
    end,
    maximized = function(size, fg_color, bg_color, hover, active)
        local img, cr = round_button(size, fg_color, bg_color, hover)

        -- draw content
        if active or hover then
            cr:set_source(gears.color(fg_color))

            local shape_size = 0.4 * size
            local thickness = shape_size / 4
            local x = (size - shape_size) / 2
            local y = (size - shape_size) / 2
            local shape = gears.shape.transform(gears.shape.cross):translate(
                x, y
            )
            shape(cr, shape_size, shape_size, thickness)
            cr:fill()
        end

        return img
    end,
    minimize = function(size, fg_color, bg_color, hover)
        local img, cr = round_button(size, fg_color, bg_color, hover)

        -- draw content
        if hover then
            cr:set_source(gears.color(fg_color))
            local shape_size = 0.4 * size
            local x = (size - shape_size) / 2
            local y = (size - shape_size / 4) / 2
            local shape =
                gears.shape.transform(gears.shape.rectangle):translate(x, y)
            shape(cr, shape_size, shape_size / 4)
            cr:fill()
        end

        return img
    end,
    ontop = function(size, fg_color, bg_color, hover, active)
        local img, cr = round_button(size, fg_color, bg_color, hover)

        -- draw content
        if active or hover then
            cr:set_source(gears.color(fg_color))

            local shape_size = 0.3 * size
            local x = (size - shape_size) / 2
            local y = (size - shape_size) / 2
            local shape =
                gears.shape.transform(gears.shape.isosceles_triangle):translate(
                    x, y
                )
            shape(cr, shape_size, shape_size)
            cr:fill()
        end

        return img
    end,
    sticky = function(size, fg_color, bg_color, hover, active)
        local img, cr = round_button(size, fg_color, bg_color, hover)

        -- draw content
        if active or hover then
            cr:set_source(gears.color(fg_color))

            local shape_size = 0.3 * size
            local shape =
                gears.shape.transform(gears.shape.isosceles_triangle):translate(
                    size / 2, size / 2
                ):rotate(math.pi):translate(-shape_size / 2, -shape_size / 2)
            shape(cr, shape_size, shape_size)
            cr:fill()
        end

        return img
    end
}
local titlebar_button = function(theme, state, postfix)
    local size = gmath.round(beautiful.get_font_height(beautiful.font) * 1.5)
    local titlebar_buttons = {
        {shape = 'close', state = state},
        {shape = 'minimize', state = state}
    }
    for _, a in ipairs({true, false}) do
        table.insert(
            titlebar_buttons, {shape = 'ontop', state = state, active = a}
        )
        table.insert(
            titlebar_buttons, {shape = 'sticky', state = state, active = a}
        )
        -- table.insert(
        --     titlebar_buttons, {shape = 'floating', state = state, active = a}
        -- )
        table.insert(
            titlebar_buttons, {shape = 'maximized', state = state, active = a}
        )
    end
    for _, tb in ipairs(titlebar_buttons) do
        local fg_color_name = string.format(
            'titlebar_%s_button_fg_%s', tb.shape, tb.state
        )
        local bg_color_name = string.format(
            'titlebar_%s_button_bg_%s', tb.shape, tb.state
        )
        local fg_color = beautiful[fg_color_name] or
                             beautiful['bg_' .. tb.state]
        local bg_color = beautiful[bg_color_name] or
                             beautiful['fg_' .. tb.state]

        local full_name = string.format(
            'titlebar_%s_button_%s', tb.shape, tb.state
        )

        if tb.active ~= nil and tb.active then
            full_name = full_name .. '_active'
        elseif tb.active ~= nil and not tb.active then
            full_name = full_name .. '_inactive'
        end
        if postfix then
            full_name = full_name .. '_' .. postfix
        end
        local img = titlebar_button_shapes[tb.shape](
            size, fg_color, bg_color, postfix, tb.active
        )
        theme[full_name] = img
    end
    return theme
end

-- [ module functions ] --------------------------------------------------------
module.init = function()
    local theme = beautiful.get()

    -- generate titlebar icons:
    theme = titlebar_button(theme, 'normal')
    theme = titlebar_button(theme, 'normal', 'hover')
    theme = titlebar_button(theme, 'normal', 'press')
    theme = titlebar_button(theme, 'focus')
    theme = titlebar_button(theme, 'focus', 'hover')
    theme = titlebar_button(theme, 'focus', 'press')

    -- exit icon
    theme.exitmenu_icon = exit_icon(
        beautiful.wibar_height or
            gmath.round(beautiful.get_font_height(beautiful.font) * 1.5),
        theme.exitmenu_icon_fg or beautiful.fg_normal,
        theme.exitmenu_icon_bg or beautiful.bg_normal
    )
    return theme
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
