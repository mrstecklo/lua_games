gl = require("opengl")
glut = require("glut")
local help = require("game_of_life.help")

local args
local map

local window = {
    width = 800,
    height = 800,
}

local neighbours = {
    {-1, -1}, { 0, -1}, { 1, -1},
    {-1,  0},           { 1,  0},
    {-1,  1}, { 0,  1}, { 1,  1},
}

local function idx(t, x, y)
    if not args.wrap and (x < 1 or x > t.width or y < 1 or y > t.height) then
        return nil
    else
        return (x - 1) % t.width + ((y - 1) % t.height) * t.width + 1
    end
end

local function at(t, x, y)
    return t[idx(t, x, y)]
end

local function EmptyMap(first, second)
    if type(first) == "table" then
        return  {
            width = first.width,
            height = first.height,
        }
    else
        return {
            width = first,
            height = second,
        }
    end
end

local function CopyMap(t)
    local r = EmptyMap(t)
    for i = 1, t.width * t.height do
        r[i] = t[i]
    end
    return r
end

local function RandomMap(first, second)
    local t = EmptyMap(first, second)
    for x = 1, t.width do
        for y = 1, t.height do
            if math.random(9) == 1 then
                t[idx(t, x, y)] = 1
            end
        end
    end
    return t
end

local function DumpMap(t)
    local file = io.open("map_" .. math.abs(math.random(0)) .. ".lua", "w+")
    file:write("return {\n")
    file:write("    width = ", t.width, ",\n")
    file:write("    height = ", t.height, ",\n")
    for y = 1, t.height do
        file:write("   ")
        for x = 1, t.width do
            file:write((at(t, x, y) and "   1" or " nil"), ",")
        end
        file:write("\n")
    end
    file:write("}\n")
    file:close()
end

local function DrapMap(t, scale)
    for x = 1, t.width do
        local left = (x - 0.5 * (1 + scale)) / t.width
        local right = left + scale / t.width
        for y = 1, t.height do
            local top = (y - 0.5 * (1 + scale)) / t.height
            local bottom = top + scale / t.height
            if(at(t, x, y)) then
                gl.Rect(left, top, right, bottom)
            end
        end
    end
end

local function NextGeneration(t)
    local ng = EmptyMap(t)
    for x = 1, t.width do
        for y = 1, t.height do
            local count = 0
            for _, n in ipairs(neighbours) do
                if at(t, x + n[1], y + n[2]) then
                    count = count + 1
                end
            end
            if (at(t, x, y) and count == 2) or (count == 3) then
                ng[idx(ng, x, y)] = 1
            end
        end
    end
    return ng
end

function Reshape(width, height)
    window.width = width
    window.height = height
    gl.Viewport(0, 0, width, height)

    gl.MatrixMode('PROJECTION')
    gl.LoadIdentity()

    gl.MatrixMode('MODELVIEW')
    gl.LoadIdentity()
end

function DrawFrame()
    gl.MatrixMode("PROJECTION")
    gl.LoadIdentity()
    gl.Ortho(0, 1, 1, 0, -1.0, 1.0)
    gl.MatrixMode("MODELVIEW")
    gl.LoadIdentity()

    gl.BlendFunc("SRC_ALPHA", "ONE_MINUS_SRC_ALPHA")

    gl.ClearColor(0,0,0,1)
    gl.Clear("DEPTH_BUFFER_BIT,COLOR_BUFFER_BIT")
    gl.Enable("BLEND")

    gl.Color( {1, 1, 0, 1} )
    DrapMap(map, 0.8)

    glut.SwapBuffers()
    gl.Flush()
end

function OnKey(key, px, py)
    local SPACE = 32
    local KEY_H = 104
    local KEY_R = 114
    local KEY_M = 109
    local KEY_C = 99

    if key == SPACE then
        map = NextGeneration(map)
    elseif key == KEY_M then
        DumpMap(map)
    elseif key == KEY_R then
        map = RandomMap(map)
    elseif key == KEY_C then
        map = EmptyMap(map)
    elseif key == KEY_H then
        map = CopyMap(help)
    end
    DrawFrame()
end

local mouse_button
local function HandleMouseButton(px, py)
    if px >= window.width or px < 0 or py >= window.height or py < 0 then
        return
    end

    local MB_LEFT = 0
    local MB_RIGHT = 2

    local x = px * map.width // window.width + 1
    local y = py * map.height // window.height + 1

    if mouse_button == MB_LEFT then
        map[idx(map, x, y)] = 1
    elseif mouse_button == MB_RIGHT then
        map[idx(map, x, y)] = nil
    end
    DrawFrame()
end

function OnMouseButton(button, state, px, py)
    local MBS_DOWN = 0

    if state == MBS_DOWN then
        mouse_button = button
        HandleMouseButton(px, py)
    end
end

function OnMouseMotion(px, py)
    HandleMouseButton(px, py)
end

local function parse_args(...)
    local args = {}
    for _, val in ipairs({...}) do
        if string.find(val, "^-") then
            if val == "--wrap" then
                args.wrap = true
            elseif string.find(val, "^--size=") then
                args.map_width, args.map_height = string.match(val, "^--size=(%d+)x(%d+)")
                args.map_width = tonumber(args.map_width)
                args.map_height = tonumber(args.map_height)
            end
        else
            args.map_module = val
        end
    end
    return args
end

args = parse_args(...)

if args.map_width and args.map_height then
    map = EmptyMap(args.map_width, args.map_height)
end

if args.map_module then
    if map then
        print("warning: both --size and <map_module> are specified. Ignoring --size option")
    end
    map = require("game_of_life." .. args.map_module)
end

map = map or CopyMap(require("game_of_life.help"))

glut.Init()
glut.InitDisplayMode()
glut.InitWindowSize(window.width, window.height)
glut.CreateWindow('Game of Life')
glut.DisplayFunc('DrawFrame')
glut.ReshapeFunc('Reshape')
glut.KeyboardFunc('OnKey')
glut.MouseFunc('OnMouseButton')
glut.MotionFunc('OnMouseMotion')

glut.MainLoop()
