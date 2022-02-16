require 'wordle.types.word'
return require('toolshed.types').def('stat', {
    __eq = function(a, b)
        return a.word == b.word
    end,
    __lt = function(a, b)
        if a.word.letters ~= b.word.letters then
            return a.word.letters > b.word.letters
        end
        return a.avg > b.avg
    end,
    __le = function(a, b)
        if a.word.letters ~= b.word.letters then
            return a.word.letters >= b.word.letters
        end
        return a.avg >= b.avg
    end,
}, function(self, stats, word)
    local total = 0
    for j = 1, word.len do
        self[j] = stats[j][word[j]]
        self.word = word
        total = total + self[j]
    end
    self.avg = total / word.len
end)
