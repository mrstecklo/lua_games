local gl = require("opengl")
local glut = require("glut")
local timer = require("timer")

local window = {
    width = 600,
    height = 600,
}

local dir = {
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    RIGHT = 4,
}

local map = {
    width = 11,
    height = 11,
}

local snake
local apple
local direction = math.random(4)
local new_direction = direction
local time
local state = true

local function DirToString(direction)
    for name, value in pairs(dir) do
        if value == direction then
            return name
        end
    end
    return "INVALID"
end

local function NewSnake()
    return {
        {
            x = map.width // 2,
            y = map.height // 2,
        }
    }
end

local function IsOutside(t, p)
    return p.x < 1 or p.x > t.width or p.y < 1 or p.y > t.height
end

local function ArePointsEqual(p1, p2)
    return p1.x == p2.x and p1.y == p2.y
end

local function DrawPoint(t, point, scale)
    local left = (point.x - 0.5 * (1 + scale)) / t.width
    local right = left + scale / t.width
    local top = (point.y - 0.5 * (1 + scale)) / t.height
    local bottom = top + scale / t.height
    gl.Rect(left, top, right, bottom)
end

local function PickPoint()
    return {
        x = math.random(map.width),
        y = math.random(map.height),
    }
end

local function PickVacantPoint()
    local result
    repeat
        local vacant = true
        result = PickPoint()
        for _, p in pairs(snake) do
            if ArePointsEqual(result, p) then
                vacant = false
                break
            end
        end
    until vacant
    return result
end

local function Init()
    snake = NewSnake()
    apple = PickVacantPoint()
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

function DrawFrame(snake_color)
    snake_color = snake_color or {1, 1, 0, 1}
    gl.MatrixMode("PROJECTION")
    gl.LoadIdentity()
    gl.Ortho(0, 1, 1, 0, -1.0, 1.0)
    gl.MatrixMode("MODELVIEW")
    gl.LoadIdentity()

    gl.BlendFunc("SRC_ALPHA", "ONE_MINUS_SRC_ALPHA")

    gl.ClearColor(0,0,0,1)
    gl.Clear("DEPTH_BUFFER_BIT,COLOR_BUFFER_BIT")
    gl.Enable("BLEND")

    gl.Color(snake_color)
    for _, p in pairs(snake) do
        DrawPoint(map, p, 0.8)
    end

    gl.Color{0, 1, 0, 1}
    DrawPoint(map, apple, 0.5)

    glut.SwapBuffers()
    gl.Flush()
end

function OnKey(key, px, py)
    local KEY_ESC = 27
    local KEY_W = 119
    local KEY_A = 97
    local KEY_S = 115
    local KEY_D = 100

    local KEY_8 = 56
    local KEY_5 = 53
    local KEY_4 = 52
    local KEY_6 = 54

    if key == KEY_ESC then
        os.exit(true, true)
    else
        if state then
            if (key == KEY_W or key == KEY_8) and direction ~= dir.DOWN then
                new_direction = dir.UP
            elseif (key == KEY_A or key == KEY_4) and direction ~= dir.RIGHT then
                new_direction = dir.LEFT
            elseif (key == KEY_S or key == KEY_5) and direction ~= dir.UP then
                new_direction = dir.DOWN
            elseif (key == KEY_D or key == KEY_6) and direction ~= dir.LEFT then
                new_direction = dir.RIGHT
            end
        else
            state = true
            Init()
            DrawFrame()
        end
    end
end

local function Move()
    local head = snake[1]
    head = {
        x = head.x,
        y = head.y,
    }
    direction = new_direction
    if direction == dir.UP then
        head.y = head.y - 1
    elseif direction == dir.DOWN then
        head.y = head.y + 1
    elseif direction == dir.LEFT then
        head.x = head.x - 1
    elseif direction == dir.RIGHT then
        head.x = head.x + 1
    end

    if IsOutside(map, head) then
        print("Outside map: ", head.x, head.y)
        print("Direction:", DirToString(direction))
        return false
    end

    for _, p in pairs(snake) do
        if ArePointsEqual(head, p) then
            print("Self collision: ", head.x, head.y)
            print("Direction:", DirToString(direction))
            return false
        end
    end

    table.insert(snake, 1, head)
    if ArePointsEqual(head, apple) then
        apple = PickVacantPoint()
    else
        table.remove(snake)
    end

    return true
end

function IdleFunc()
    local period_ms = 500
    local milli = 1000
    local modulo_s = 10
    local modulo_ms = modulo_s * milli
    if state then
        local now_s, now_ms = timer.GetTime()
        local now = (now_s % modulo_s) * milli + now_ms
        time = time or now
        local next_time = time + period_ms
        if next_time >= modulo_ms and now < time then
            next_time = next_time % modulo_ms
        end
        if now > next_time then
            time = now
            if Move() then
                DrawFrame()
            else
                print("Game over. Snake size: ", #snake)
                DrawFrame{1, 0, 0, 1}
                state = false
            end
        end
    end
end

Init()

glut.Init()
glut.InitDisplayMode()
glut.InitWindowSize(window.width, window.height)
glut.CreateWindow('Snake')
glut.DisplayFunc('DrawFrame')
glut.ReshapeFunc('Reshape')
glut.KeyboardFunc('OnKey')
glut.IdleFunc('IdleFunc')

glut.MainLoop()
