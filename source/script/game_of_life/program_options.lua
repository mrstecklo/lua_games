local argparse = require("argparse")

local function convert_size(str)
    local w, h = string.match(str, "^(%d+)x(%d+)$")
    if w and h then
        return {
            width = tonumber(w),
            height = tonumber(h),
        }
    end
    return nil, "option '--size' must be <width>x<height>"
end

local function parse(...)
    local parser = argparse("game_of_life/main.lua", "Conway's Game of Life")
    parser:argument("map_module", "Map module file name, e.g. 'gospers_gun'")
        :args("?")
    parser:flag("--wrap", "Wrap map around")
    parser:option("--size", "Map size. <width>x<height>")
        :convert(convert_size)
    local args = parser:parse{...}
    if args.size and args.map_module then
        print("Warning: both '--size' and '<map_module>' are specified. Ignoring '--size' option")
        args.size = nil
    end
    return args
end

return {
    parse = parse,
}
