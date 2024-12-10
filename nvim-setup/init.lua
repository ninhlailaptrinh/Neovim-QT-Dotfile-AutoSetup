require('plugins')
require('plugins.settings')

-- Cấu hình LSP log level
vim.lsp.set_log_level("ERROR")

-- Tắt các diagnostic không cần thiết
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
