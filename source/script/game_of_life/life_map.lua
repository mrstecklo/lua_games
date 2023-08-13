local map = require("common.map")

local neighbours = {
    {-1, -1}, { 0, -1}, { 1, -1},
    {-1,  0},           { 1,  0},
    {-1,  1}, { 0,  1}, { 1,  1},
}

local function next_generation(t, wrap)
    local ng = map.empty(t)
    for i in map.pairs(t) do
        local x, y = map.coord(t, i)
        for _, n in pairs(neighbours) do
            local ng_i = map.idx(ng, x + n[1], y + n[2], wrap)
            if ng_i then
                ng[ng_i] = (ng[ng_i] or 0) + 1
            end
        end
    end

    for i, count in map.pairs(ng) do
        if count == 3 or (t[i] and count == 2) then
            ng[i] = 1
        else
            ng[i] = nil
        end
    end
    return ng
end

return {
    next_generation = next_generation,
}
