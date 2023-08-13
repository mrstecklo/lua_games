local gl = require("opengl")
local glut = require("glut")
local help = require("game_of_life.data.help")
local map = require("common.map")
local life_map = require("game_of_life.life_map")
local argparse = require("argparse")

local args
local game_map

local window = {
    width = 800,
    height = 800,
}

local function DrawMap(t, scale)
    for i in map.pairs(t) do
        local x, y = map.coord(t, i)
        local left = (x - 0.5 * (1 + scale)) / t.width
        local right = left + scale / t.width
        local top = (y - 0.5 * (1 + scale)) / t.height
        local bottom = top + scale / t.height
        gl.Rect(left, top, right, bottom)
    end
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
    DrawMap(game_map, 0.8)

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
        game_map = life_map.next_generation(game_map, args.wrap)
    elseif key == KEY_M then
        map.dump(game_map, "map_" .. math.abs(math.random(0)) .. ".lua")
    elseif key == KEY_R then
        game_map = map.random(game_map)
    elseif key == KEY_C then
        game_map = map.empty(game_map)
    elseif key == KEY_H then
        game_map = map.copy(help)
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

    local x = px * game_map.width // window.width + 1
    local y = py * game_map.height // window.height + 1

    if mouse_button == MB_LEFT then
        game_map[map.idx(game_map, x, y)] = 1
    elseif mouse_button == MB_RIGHT then
        game_map[map.idx(game_map, x, y)] = nil
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
    local parser = argparse("game_of_life/main.lua", "Conway's Game of Life")
    parser:argument("map_module", "Map module file name, e.g. 'gospers_gun'"):args("?")
    parser:flag("--wrap", "Wrap map around")
    parser:option("--size", "Map size. <width>x<height>")
        :convert(
            function(str)
                local w, h = string.match(str, "^(%d+)x(%d+)$")
                local result = {
                    width = tonumber(w),
                    height = tonumber(h),
                }
                if result.width and result.height then
                    return result
                end
                return nil, "option '--size' must be <width>x<height>"
            end
        )
    local args = parser:parse{...}
    if args.size and args.map_module then
        print("Warning: both '--size' and '<map_module>' are specified. Ignoring '--size' option")
        args.size = nil
    end
    return args
end

args = parse_args(...)

if args.size then
    game_map = map.empty(args.size)
elseif args.map_module then
    local success
    success, game_map = pcall(require, "game_of_life.data." .. args.map_module)
    if not success then
        print("Warning: cant find map module '" .. args.map_module .. ".lua' in game_of_life/data")
        game_map = nil
    end
end

game_map = game_map or map.copy(help)

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
