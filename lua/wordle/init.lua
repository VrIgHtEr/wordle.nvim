local wordle = {}
local types = require 'toolshed.types'
require 'wordle.types.wordle'

print(table.concat(types.wordle.get_prediction 'cares 00010', ' '))

return wordle
