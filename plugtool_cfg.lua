return {
    needs = { 'MunifTanjim/nui.nvim' },
    after = { 'MunifTanjim/nui.nvim' },
    config = function()
        nnoremap('<leader>wordle', require('wordle.ui').show, 'silent', 'show the wordle helper')
    end,
}
