local lu = require("luaunit")
local map = require("common.map")

TestMap = {}

function TestMap:test_pairs()
    local keys = {}
    local values = {}
    local t = {
        width = 3,
        height = 4,
        1,  nil,2,
        nil,3,  nil,
        4,  5,  6,
        nil,nil,nil,
        7,  8,  9,
    }

    for k, v in map.pairs(t) do
        table.insert(keys, k)
        values[k] = v
    end

    table.sort(keys)
    lu.assertEquals(keys, {1, 3, 5, 7, 8, 9})
    lu.assertEquals(values, {
        1,  nil,2,
        nil,3,  nil,
        4,  5,  6,
        nil,nil,nil,
    })
end

function TestMap:test_coord()
    local t = {
        width = 17,
        height = 23,
    }

    lu.assertEquals({map.coord(t, 1)}, {1, 1})
    lu.assertEquals({map.coord(t, 2)}, {2, 1})
    lu.assertEquals({map.coord(t, 17)}, {17, 1})
    lu.assertEquals({map.coord(t, 18)}, {1, 2})
    lu.assertEquals({map.coord(t, 19)}, {2, 2})
    lu.assertEquals({map.coord(t, 34)}, {17, 2})
    lu.assertEquals({map.coord(t, 391)}, {17, 23})
end

function TestMap:test_at__InsideRectangle()
    local rectangle = require("test.common.data.rectangle")
    local expected = {
        {1, 1, 1},  {2, 1, 1},    {3, 1, 1},    {4, 1, 1},    {5, 1, 1},    {6, 1, 1},    {7, 1, 1},    {8, 1, 1},    {9, 1, 1},    {10, 1, 1},
        {1, 2, 1},  {2, 2, nil},  {3, 2, nil},  {4, 2, nil},  {5, 2, nil},  {6, 2, nil},  {7, 2, nil},  {8, 2, nil},  {9, 2, nil},  {10, 2, 1},
        {1, 3, 1},  {2, 3, nil},  {3, 3, nil},  {4, 3, nil},  {5, 3, nil},  {6, 3, nil},  {7, 3, nil},  {8, 3, nil},  {9, 3, nil},  {10, 3, 1},
        {1, 4, 1},  {2, 4, nil},  {3, 4, nil},  {4, 4, nil},  {5, 4, nil},  {6, 4, nil},  {7, 4, nil},  {8, 4, nil},  {9, 4, nil},  {10, 4, 1},
        {1, 5, 1},  {2, 5, nil},  {3, 5, nil},  {4, 5, nil},  {5, 5, nil},  {6, 5, nil},  {7, 5, nil},  {8, 5, nil},  {9, 5, nil},  {10, 5, 1},
        {1, 6, 1},  {2, 6, nil},  {3, 6, nil},  {4, 6, nil},  {5, 6, nil},  {6, 6, nil},  {7, 6, nil},  {8, 6, nil},  {9, 6, nil},  {10, 6, 1},
        {1, 7, 1},  {2, 7, nil},  {3, 7, nil},  {4, 7, nil},  {5, 7, nil},  {6, 7, nil},  {7, 7, nil},  {8, 7, nil},  {9, 7, nil},  {10, 7, 1},
        {1, 8, 1},  {2, 8, nil},  {3, 8, nil},  {4, 8, nil},  {5, 8, nil},  {6, 8, nil},  {7, 8, nil},  {8, 8, nil},  {9, 8, nil},  {10, 8, 1},
        {1, 9, 1},  {2, 9, nil},  {3, 9, nil},  {4, 9, nil},  {5, 9, nil},  {6, 9, nil},  {7, 9, nil},  {8, 9, nil},  {9, 9, nil},  {10, 9, 1},
        {1, 10, 1}, {2, 10, nil}, {3, 10, nil}, {4, 10, nil}, {5, 10, nil}, {6, 10, nil}, {7, 10, nil}, {8, 10, nil}, {9, 10, nil}, {10, 10, 1},
        {1, 11, 1}, {2, 11, nil}, {3, 11, nil}, {4, 11, nil}, {5, 11, nil}, {6, 11, nil}, {7, 11, nil}, {8, 11, nil}, {9, 11, nil}, {10, 11, 1},
        {1, 12, 1}, {2, 12, nil}, {3, 12, nil}, {4, 12, nil}, {5, 12, nil}, {6, 12, nil}, {7, 12, nil}, {8, 12, nil}, {9, 12, nil}, {10, 12, 1},
        {1, 13, 1}, {2, 13, nil}, {3, 13, nil}, {4, 13, nil}, {5, 13, nil}, {6, 13, nil}, {7, 13, nil}, {8, 13, nil}, {9, 13, nil}, {10, 13, 1},
        {1, 14, 1}, {2, 14, nil}, {3, 14, nil}, {4, 14, nil}, {5, 14, nil}, {6, 14, nil}, {7, 14, nil}, {8, 14, nil}, {9, 14, nil}, {10, 14, 1},
        {1, 15, 1}, {2, 15, nil}, {3, 15, nil}, {4, 15, nil}, {5, 15, nil}, {6, 15, nil}, {7, 15, nil}, {8, 15, nil}, {9, 15, nil}, {10, 15, 1},
        {1, 16, 1}, {2, 16, nil}, {3, 16, nil}, {4, 16, nil}, {5, 16, nil}, {6, 16, nil}, {7, 16, nil}, {8, 16, nil}, {9, 16, nil}, {10, 16, 1},
        {1, 17, 1}, {2, 17, 1},   {3, 17, 1},   {4, 17, 1},   {5, 17, 1},   {6, 17, 1},   {7, 17, 1},   {8, 17, 1},   {9, 17, 1},   {10, 17, 1},
    }
    for _, e in pairs(expected) do
        lu.assertEquals(
            map.at(rectangle, e[1], e[2]),
            e[3],
            "{" .. e[1] .. ", " .. e[2] .. "}"
        )
        lu.assertEquals(
            map.at(rectangle, e[1], e[2], true),
            e[3],
            "{" .. e[1] .. ", " .. e[2] .. "}"
        )
    end
end

function TestMap:test_at__OutsideRectangle()
    local rectangle = require("test.common.data.rectangle")
    local expected = {
        {0, 0, 1},
        {0, 1, 1},
        {-1, -1, nil},
        {-8, -5, nil},
        {-9, -16, 1},
        {-10, -17, 1},
        {-11, -18, nil},
        {10, 25, 1},
        {5, 25, nil},
        {25, 5, nil},
        {100, 17, 1},
        {100, 170, 1},
    }
    for _, e in pairs(expected) do
        lu.assertEquals(
            map.at(rectangle, e[1], e[2]),
            nil,
            "{" .. e[1] .. ", " .. e[2] .. "}"
        )
        lu.assertEquals(
            map.at(rectangle, e[1], e[2], true),
            e[3],
            "{" .. e[1] .. ", " .. e[2] .. "}"
        )
    end
end

assert(0 == lu.LuaUnit.run())
