local ui = {}

local types = require 'toolshed.types'
require 'wordle.types.wordle'

local Popup = require 'nui.popup'
local event = require('nui.utils.autocmd').event

function ui.show()
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

    local function trim(s)
        local a = s:match '^%s*()'
        local b = s:match('()%s*$', a)
        return s:sub(a, b - 1)
    end

    local prev = ''
    local predictions = {}

    popup:mount()
    popup:on(event.TextChangedI, function(evt)
        vim.api.nvim_exec('mes clear', true)
        local lines = vim.api.nvim_buf_get_lines(evt.buf, 0, -1, true)
        --trim all lines until the first empty line and discard the rest
        local add = true
        for i = 1, #lines do
            if add then
                lines[i] = trim(lines[i])
                if lines[i]:len() == 0 then
                    add = false
                end
            else
                lines[i] = nil
            end
        end

        local query = {}
        do
            local qidx = 0
            add = true
            for i, x in ipairs(lines) do
                local word, result
                local space = x:find ' '
                if space then
                    word, result = trim(x:sub(1, space - 1)), trim(x:sub(space + 1))
                else
                    word, result = trim(x), ''
                end

                do
                    if word:len() > 5 then
                        word = word:sub(1, 5)
                    end
                    local chars, idx = {}, 0
                    for j = 1, word:len() do
                        local z = word:sub(j, j):byte()
                        if z >= 97 or z <= 122 then
                            idx = idx + 1
                            chars[idx] = string.char(z)
                        end
                    end
                    word = table.concat(chars)
                end
                do
                    if result:len() > 5 then
                        result = result:sub(1, 5)
                    end
                    local chars, idx = {}, 0
                    for j = 1, result:len() do
                        local z = result:sub(j, j)
                        if z == '0' or z == '1' or z == '2' then
                            idx = idx + 1
                            chars[idx] = z
                        end
                    end
                    result = table.concat(chars)
                end
                local concat = word .. ' ' .. result
                lines[i] = concat
                if add and word:len() == 5 and result:len() == 5 then
                    qidx = qidx + 1
                    query[qidx] = concat
                else
                    add = false
                end
            end
        end
        if lines[#lines]:len() > 0 then
            table.insert(lines, '')
        end

        query = table.concat(query, ' ')
        local lastline = #lines

        if query ~= prev then
            prev = query
            predictions = types.wordle.get_prediction(query)

            local idx = #lines

            for _, x in ipairs(predictions) do
                idx = idx + 1
                lines[idx] = x
            end
            lastline = -1
        end
        vim.api.nvim_buf_set_lines(evt.buf, 0, lastline, false, lines)
    end)

    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
end

return ui
