local ui = {}
local Popup = require 'nui.popup'
local event = require('nui.utils.autocmd').event

local popup = Popup {
    enter = true,
    focusable = true,
    border = { style = 'rounded' },
    position = '50%',
    size = {
        width = '80%',
        height = '60%',
    },
    buf_options = {
        modifiable = true,
        readonly = false,
    },
}
popup:mount()
popup:on(event.TextChangedI, function(...)
    print(vim.inspect { ... })
end)

popup:on(event.BufLeave, function()
    popup:unmount()
end)

return ui
