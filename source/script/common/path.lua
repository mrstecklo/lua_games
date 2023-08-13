local map = require("common.map")

local neighbours = {
            { 0, -1},
    {-1,  0},       { 1,  0},
            { 0,  1},
}

local function expand_wave(t, start, finish)
    local weight = map.empty(t)
    weight[map.idx(weight, start[1], start[2])] = 0
    local wave = {start}
    for _, current in ipairs(wave) do
        if current[1] == finish[1] and current[2] == finish[2] then
            return weight
        end
        local w = map.at(weight, current[1], current[2])
        assert(w)
        for _, n in pairs(neighbours) do
            local x = current[1] + n[1]
            local y = current[2] + n[2]
            local ni = map.idx(t, x, y)
            if ni and not weight[ni] and not t[ni] then
                weight[ni] = w + 1
                table.insert(wave, {x, y})
            end
        end
    end
end

local function backtrace(weight, finish)
    local result = {}
    local current = {finish[1], finish[2]}
    while true do
        local w = map.at(weight, current[1], current[2])
        assert(w)
        if w == 0 then
            return result
        end
        w = w - 1
        for _, n in pairs(neighbours) do
            local x = current[1] + n[1]
            local y = current[2] + n[2]
            local ni = map.idx(weight, x, y)
            if ni and weight[ni] == w then
                table.insert(result, 1, current)
                current = {x, y}
            end
        end
    end
end

local function find(t, start, finish)
    if map.idx(t, finish[1], finish[2]) then
        local weight = expand_wave(t, start, finish)
        if weight then
            return backtrace(weight, finish)
        end
    end
end

return {
    find = find,
}
