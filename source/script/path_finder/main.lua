local gl = require("opengl")
local glut = require("glut")
local map = require("common.map")
local path = require("common.path")
local timer = require("timer")

local window = {
    width = 800,
    height = 800,
}
local game_map = require("path_finder.data.map")
local unit = {
    coord = {1, 1},
    path = {},
}

local function DrawCell(t, x, y, scale)
    local left = (x - 0.5 * (1 + scale)) / t.width
    local right = left + scale / t.width
    local top = (y - 0.5 * (1 + scale)) / t.height
    local bottom = top + scale / t.height
    gl.Rect(left, top, right, bottom)
end

local function DrawMap(t, scale)
    for i in map.pairs(t) do
        local x, y = map.coord(t, i)
        DrawCell(t, x, y, scale)
    end
end

local function DrawUnit(t, u, scale)
    DrawCell(t, u[1], u[2], scale)
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
    gl.Color( {1, 0, 0, 1} )
    DrawUnit(game_map, unit.coord, 0.5)

    glut.SwapBuffers()
    gl.Flush()
end

local mouse_button
local function HandleMouseButton(px, py)
    if px >= window.width or px < 0 or py >= window.height or py < 0 then
        return
    end

    local MB_LEFT = 0
    local MB_MIDDLE = 1
    local MB_RIGHT = 2

    local x = px * game_map.width // window.width + 1
    local y = py * game_map.height // window.height + 1

    local finish
    if mouse_button == MB_LEFT then
        game_map[map.idx(game_map, x, y)] = 1
        finish = unit.path[#unit.path]
    elseif mouse_button == MB_RIGHT then
        finish = {x, y}
    elseif mouse_button == MB_MIDDLE then
        game_map[map.idx(game_map, x, y)] = nil
        finish = unit.path[#unit.path]
    end
    if finish then
        unit.path = path.find(game_map, unit.coord, finish) or {}
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

function IdleFunc()
    local period_ms = 200
    local milli = 1000
    local modulo_s = 10
    local modulo_ms = modulo_s * milli

    local now_s, now_ms = timer.GetTime()
    local now = (now_s % modulo_s) * milli + now_ms
    time = time or now
    local next_time = time + period_ms
    if next_time >= modulo_ms and now < time then
        next_time = next_time % modulo_ms
    end
    if now > next_time then
        time = now
        if unit.path[1] then
            unit.coord = unit.path[1]
            table.remove(unit.path, 1)
            DrawFrame()
        end
    end
end

glut.Init()
glut.InitDisplayMode()
glut.InitWindowSize(window.width, window.height)
glut.CreateWindow('Path Finder')
glut.DisplayFunc('DrawFrame')
glut.ReshapeFunc('Reshape')
glut.MouseFunc('OnMouseButton')
glut.MotionFunc('OnMouseMotion')
glut.IdleFunc('IdleFunc')

glut.MainLoop()
