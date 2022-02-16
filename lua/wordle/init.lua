local wordle = {}
local types = require 'toolshed.types'

require 'wordle.types.wordle'

print('ATTEMPT 0: ' .. table.concat(types.wordle.get_prediction '', ' '))
print '---'
print('ATTEMPT 1: ' .. table.concat(types.wordle.get_prediction 'cares 01100', ' '))
print '---'
print('ATTEMPT 2: ' .. table.concat(types.wordle.get_prediction 'cares 01100 grant 02100', ' '))
print '---'
print('ATTEMPT 3: ' .. table.concat(types.wordle.get_prediction 'cares 01100 grant 02100 prial 02010', ' '))
print '---'
print('ATTEMPT 4: ' .. table.concat(types.wordle.get_prediction 'cares 01100 grant 02100 prial 02010 aroba 22202', ' '))
print '---'
print('ATTEMPT 5: ' .. table.concat(types.wordle.get_prediction 'cares 01100 grant 02100 prial 02010 aroba 22202 aroha 22202', ' '))
print '---'
print('ATTEMPT 6: ' .. table.concat(types.wordle.get_prediction 'cares 01100 grant 02100 prial 02010 aroba 22202 aroha 22202', ' '))

return wordle
