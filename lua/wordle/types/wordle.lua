local string = require 'toolshed.util.string.global'
require 'wordle.types.stat'
local types = require 'toolshed.types'
local dict = require 'wordle.dict'
return types.def('wordle', {
    word_stats = function(self)
        local stats = {}
        for i = 1, self.length do
            stats[i] = {}
            for j = 1, 26 do
                stats[i][j] = 0
            end
        end
        for _, w in ipairs(self.dict) do
            for i, c in ipairs(w) do
                stats[i][c] = stats[i][c] + 1
            end
        end
        local dlen = 1.0 / #self.dict
        for i = 1, self.length do
            for j = 1, 26 do
                stats[i][j] = stats[i][j] * dlen
            end
        end

        local ret = {}
        for i, w in ipairs(self.dict) do
            ret[i] = types.stat.new(stats, w)
        end
        table.sort(ret)
        return ret
    end,
    filter = function(self, word, response)
        if type(response) == 'string' then
            if response:len() ~= self.length then
                return
            end
            local t = {}
            for i = 1, self.length do
                t[i] = tonumber(response:sub(i, i))
            end
            response = t
        end
        if type(word) ~= 'string' or word:len() ~= self.length or type(response) ~= 'table' or #response ~= self.length then
            return
        else
            for _, x in ipairs(response) do
                if type(x) ~= 'number' or x < 0 or x > 2 then
                    return
                end
            end
            local t = {}
            for c in string.codepoints(word) do
                table.insert(t, string.byte(c) - 96)
            end
            word = t
        end
        local guess = {}
        local minimum, maximum, excludedalphabet = {}, {}, {}
        for i = 1, 26 do
            minimum[i] = 0
        end
        local exclusions = {}
        for i, x in ipairs(response) do
            if x == 0 then
                excludedalphabet[word[i]] = true
            else
                if x == 1 then
                    exclusions[i] = word[i]
                elseif x == 2 then
                    guess[i] = word[i]
                end
                minimum[word[i]] = minimum[word[i]] + 1
            end
        end
        for i = 1, 26 do
            maximum[i] = excludedalphabet[i] and minimum[i] or self.length
        end
        local newdict = {}
        for _, w in ipairs(self.dict) do
            local hist = {}
            for i = 1, 26 do
                hist[i] = 0
            end
            for i = 1, self.length do
                if exclusions[i] and w[i] == exclusions[i] or guess[i] and guess[i] ~= w[i] then
                    goto skip
                end
                hist[w[i]] = hist[w[i]] + 1
            end
            for i = 1, 26 do
                if hist[i] < minimum[i] or hist[i] > maximum[i] then
                    goto skip
                end
            end
            table.insert(newdict, w)
            ::skip::
        end
        self.dict = newdict
        return self
    end,
    get_prediction = function(...)
        local args = { ... }
        local length = 5
        if #args > 0 and type(args[1]) == 'number' then
            length = args[1]
            table.remove(args, 1)
            if length < 1 then
                return
            end
        end
        if #args == 1 and type(args[1]) == 'string' then
            args = vim.split(args[1], ' ', { plain = true, trimempty = true })
        end
        if #args % 2 == 0 then
            local game = types.wordle.new(length)
            for i = 1, #args / 2 do
                game:filter(args[i * 2 - 1], args[i * 2])
            end
            local ret = game:word_stats()
            for i, x in ipairs(ret) do
                ret[i] = x.word.string
            end
            return ret
        end
    end,
}, function(game, length)
    game.dict = {}
    local idx = 0
    for _, x in ipairs(dict) do
        if x.len == length then
            idx = idx + 1
            game.dict[idx] = x
        end
    end
    game.length = length
end)
