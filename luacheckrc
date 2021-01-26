-- Only allow symbols available in all Lua versions
std = "min"

include_files = {
    "*.lua",            -- libraries
    "rc/*.lua",    -- officially supported widget types
}

-- Warnings to be ignored
ignore = {
}

-- Not enforced, but preferable
max_code_line_length = 80