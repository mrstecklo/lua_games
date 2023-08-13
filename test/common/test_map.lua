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

assert(0 == lu.LuaUnit.run())
