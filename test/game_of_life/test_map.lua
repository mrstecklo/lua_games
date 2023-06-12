local lu = require("luaunit")
local map = require("game_of_life.map")

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

assert(0 == lu.LuaUnit.run())
