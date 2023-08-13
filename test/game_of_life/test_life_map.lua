local lu = require("luaunit")
local map = require("common.map")
local life_map = require("game_of_life.life_map")

TestLifeMap = {}

function TestLifeMap:test_next_generation()
    lu.assertEquals(life_map.next_generation({
            width = 3,
            height = 3,
            nil, 1, nil,
            nil, 1, nil,
            nil, 1, nil,
        }),
        {
            width = 3,
            height = 3,
            nil, nil, nil,
            1,   1,   1,
            nil, nil, nil,
        }
    )

    lu.assertEquals(life_map.next_generation({
            width = 5,
            height = 4,
            nil, nil, 1,   nil, nil,
            nil, nil, 1,   nil, nil,
            nil, nil, nil, nil, nil,
            nil, nil, 1,   nil, nil,
        }),
        {
            width = 5,
            height = 4,
        }
    )
end

function TestLifeMap:test_next_generation_wrap()
    lu.assertEquals(life_map.next_generation({
            width = 5,
            height = 4,
            nil, nil, 1,   nil, nil,
            nil, nil, 1,   nil, nil,
            nil, nil, nil, nil, nil,
            nil, nil, 1,   nil, nil,
        }, true),
        {
            width = 5,
            height = 4,
            nil, 1,   1,   1,   nil,
            nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil,
        }
    )
end

assert(0 == lu.LuaUnit.run())
