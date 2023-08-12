local lu = require("luaunit")
local map = require("game_of_life.map")
local path = require("path_finder.path")

TestMap = {}

function TestMap.test_find__DoesNotGoOutside()
    local t = map.empty(10, 5)
    lu.assertEquals(path.find(t, {1, 1}, {0, 1}), nil)
    lu.assertEquals(path.find(t, {1, 1}, {1, 0}), nil)
    lu.assertEquals(path.find(t, {1, 1}, {11, 1}), nil)
    lu.assertEquals(path.find(t, {1, 1}, {1, 6}), nil)
end

function TestMap.test_find__HandlesStraightLines()
    local t = map.empty(10, 10)
    lu.assertEquals(path.find(t, {1, 1}, {1, 1}), {})
    lu.assertEquals(path.find(t, {1, 2}, {2, 2}), {{2, 2}})
    lu.assertEquals(path.find(t, {2, 1}, {2, 2}), {{2, 2}})
    lu.assertEquals(path.find(t, {2, 1}, {1, 1}), {{1, 1}})
    lu.assertEquals(path.find(t, {1, 1}, {1, 3}), {{1, 2}, {1, 3}})
    lu.assertEquals(path.find(t, {1, 1}, {1, 4}), {{1, 2}, {1, 3}, {1, 4}})
    lu.assertEquals(path.find(t, {2, 1}, {2, 4}), {{2, 2}, {2, 3}, {2, 4}})
    lu.assertEquals(path.find(t, {1, 1}, {1, 5}), {{1, 2}, {1, 3}, {1, 4}, {1, 5}})
    lu.assertEquals(path.find(t, {1, 1}, {3, 1}), {{2, 1}, {3, 1}})
end

function TestMap.test_find__HandlesShortDiagonal()
    local t = map.empty(10, 10)
    local p = path.find(t, {1, 1}, {2, 2})
    lu.assertEquals(#p, 2)
    lu.assertEquals(p[2], {2, 2})
    lu.assertTableContains({{1, 2}, {2, 1}}, p[1])
end

function TestMap.test_find__HandlesRectangleDiagonal()
    local t = map.empty(10, 10)
    local start = {1, 1}
    local finish = {2, 10}
    local p = path.find(t, start, finish)
    lu.assertEquals(#p, 10)
    lu.assertEquals(p[#p], finish)
    table.insert(p, 1, start)
    local area = {
                {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {1, 8}, {1, 9}, {1, 10},
        {2, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}, {2, 8}, {2, 9}, {2, 10},
    }
    for i = 2, #p do
        lu.assertTableContains(area, p[i], "index: " .. i)
        local x = p[i][1]
        local y = p[i][2]
        if x == p[i - 1][1] then
            lu.assertEquals(p[i - 1], {x, y - 1})
        else
            lu.assertEquals(p[i - 1], {x - 1, y})
        end
    end
end

function TestMap.test_find__HandlesSouthWestDiagonal()
    local t = map.empty(10, 10)
    local start = {1, 10}
    local finish = {10, 1}
    local p = path.find(t, start, finish)
    lu.assertEquals(#p, 18)
    lu.assertEquals(p[#p], finish)
    table.insert(p, 1, start)
    local area = {
        {1, 1},  {1, 2},  {1, 3},  {1, 4},  {1, 5},  {1, 6},  {1, 7},  {1, 8},  {1, 9},
        {2, 1},  {2, 2},  {2, 3},  {2, 4},  {2, 5},  {2, 6},  {2, 7},  {2, 8},  {2, 9},  {2, 10},
        {3, 1},  {3, 2},  {3, 3},  {3, 4},  {3, 5},  {3, 6},  {3, 7},  {3, 8},  {3, 9},  {3, 10},
        {4, 1},  {4, 2},  {4, 3},  {4, 4},  {4, 5},  {4, 6},  {4, 7},  {4, 8},  {4, 9},  {4, 10},
        {5, 1},  {5, 2},  {5, 3},  {5, 4},  {5, 5},  {5, 6},  {5, 7},  {5, 8},  {5, 9},  {5, 10},
        {6, 1},  {6, 2},  {6, 3},  {6, 4},  {6, 5},  {6, 6},  {6, 7},  {6, 8},  {6, 9},  {6, 10},
        {7, 1},  {7, 2},  {7, 3},  {7, 4},  {7, 5},  {7, 6},  {7, 7},  {7, 8},  {7, 9},  {7, 10},
        {8, 1},  {8, 2},  {8, 3},  {8, 4},  {8, 5},  {8, 6},  {8, 7},  {8, 8},  {8, 9},  {8, 10},
        {9, 1},  {9, 2},  {9, 3},  {9, 4},  {9, 5},  {9, 6},  {9, 7},  {9, 8},  {9, 9},  {9, 10},
        {10, 1}, {10, 2}, {10, 3}, {10, 4}, {10, 5}, {10, 6}, {10, 7}, {10, 8}, {10, 9}, {10, 10},
    }
    for i = 2, #p do
        lu.assertTableContains(area, p[i], "index: " .. i)
        local x = p[i][1]
        local y = p[i][2]
        if x == p[i - 1][1] then
            lu.assertEquals(p[i - 1], {x, y + 1})
        else
            lu.assertEquals(p[i - 1], {x - 1, y})
        end
    end
end

function TestMap.test_find__GoesAroundObstacle()
    local t = {
        width = 3,
        height = 3,
        nil, nil, nil,
          1,   1, nil,
        nil, nil, nil,
    }

    lu.assertEquals(
        path.find(t, {1, 1}, {1, 3}),
        {{2, 1}, {3, 1}, {3, 2}, {3, 3}, {2, 3}, {1, 3}}
    )
end

function TestMap.test_find__CantWalkThroughWall()
    local t = {
        width = 3,
        height = 3,
        nil, nil, nil,
          1,   1,   1,
        nil, nil, nil,
    }

    lu.assertEquals(
        path.find(t, {1, 1}, {1, 3}),
        nil
    )
end

function TestMap.test_find__DoesNotReuseFinish()
    local t = map.empty(10, 10)
    local finish = {1, 2}
    local p = path.find(t, {1, 1}, finish)
    finish[1] = 100
    lu.assertEquals(p, {{1, 2}})
end

assert(0 == lu.LuaUnit.run())
