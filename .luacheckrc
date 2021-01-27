-- Only allow symbols available in all Lua versions
std = "min"

include_files = {
    "*.lua",
    "rc/**/**/*.lua"
}

-- Warnings to be ignored
ignore = {}

-- Not enforced, but preferable
max_code_line_length = 80

-- Global objects defined by the C code
read_globals = {
    "awesome",
    "button",
    "dbus",
    "drawable",
    "drawin",
    "key",
    "keygrabber",
    "mousegrabber",
    "selection",
    "tag",
    "window",
    "table.unpack",
    "math.atan2",
}

-- screen may not be read-only, because newer luacheck versions complain about
-- screen[1].tags[1].selected = true.
-- The same happens with the following code:
--   local tags = mouse.screen.tags
--   tags[7].index = 4
-- client may not be read-only due to client.focus.
globals = {
    "screen",
    "mouse",
    "root",
    "client"
}

-- Enable cache (uses .luacheckcache relative to this rc file).
cache = true

-- Do not enable colors to make the Travis CI output more readable.
-- color = false
