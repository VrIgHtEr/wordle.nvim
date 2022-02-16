local fnil = function() end
return require('toolshed.types').def('word', {
    len = 0,
    letters = 0,
    __eq = function(a, b)
        return a.string == b.string
    end,
    __lt = function(a, b)
        return a.string < b.string
    end,
    __le = function(a, b)
        return a.string <= b.string
    end,
    __len = function(self)
        return self.len
    end,
    __tostring = function(self)
        return self.string
    end,
}, function(self, line)
    self.hist = {}
    for i = 1, 26 do
        self.hist[i] = 0
    end
    for char in string.codepoints(line) do
        local val = char:len() == 1 and char:byte() - 96 or 0
        if val >= 1 and val <= 26 then
            self.len = self.len + 1
            self[self.len] = val
            self.hist[self[self.len]] = self.hist[self[self.len]] + 1
        end
    end

    for i = 1, 26 do
        if self.hist[i] > 0 then
            self.letters = self.letters + 1
        else
            self.hist[i] = nil
        end
    end

    local str = {}
    for i, x in ipairs(self) do
        str[i] = string.char(x + 96)
    end
    self.string = table.concat(str)
    setmetatable(self.hist, { __newindex = fnil, __metatable = fnil })
end)
