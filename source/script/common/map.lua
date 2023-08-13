local function idx(t, x, y, wrap)
    if not wrap and (x < 1 or x > t.width or y < 1 or y > t.height) then
        return nil
    else
        return (x - 1) % t.width + ((y - 1) % t.height) * t.width + 1
    end
end

local function at(t, x, y, wrap)
    return t[idx(t, x, y, wrap)]
end

local function coord(t, i)
    return (i - 1) % t.width + 1, 1 + (i - 1) // t.width
end

local function map_pairs(t)
    local f, s, k = pairs(t)
    local size = t.width * t.height
    local iterator = function (state, key)
        repeat
            local value
            key, value = f(state, key)
            if type(key) == "number" and key <= size then
                return key, value
            end
        until key == nil
    end
    return iterator, s, k
end

local function empty(first, second)
    if type(first) == "table" then
        return  {
            width = first.width,
            height = first.height,
        }
    else
        return {
            width = first,
            height = second,
        }
    end
end

local function copy(t)
    local r = {}
    for k, v in pairs(t) do
        r[k] = v
    end
    return r
end

local function random(first, second)
    local t = empty(first, second)
    for i = 1, t.width * t.height do
        if math.random(9) == 1 then
            t[i] = 1
        end
    end
    return t
end

local function dump(t, name)
    local file = io.open(name, "w+")
    file:write("return {\n")
    file:write("    width = ", t.width, ",\n")
    file:write("    height = ", t.height, ",\n")
    for y = 1, t.height do
        file:write("   ")
        for x = 1, t.width do
            file:write((at(t, x, y) and "   1" or " nil"), ",")
        end
        file:write("\n")
    end
    file:write("}\n")
    file:close()
end

return {
    idx = idx,
    at = at,
    coord = coord,
    pairs = map_pairs,
    empty = empty,
    copy = copy,
    random = random,
    dump = dump,
}
