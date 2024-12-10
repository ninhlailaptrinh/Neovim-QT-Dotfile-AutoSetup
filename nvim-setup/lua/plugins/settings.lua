-- Cấu hình cơ bản
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.mouse = 'a'
vim.opt.encoding = 'UTF-8'
vim.opt.background = 'dark'
vim.opt.clipboard = "unnamedplus"

-- Cấu hình theme onedark
require('onedark').setup {
    style = 'dark',
    transparent = true,
    term_colors = true,
}
require('onedark').load()

-- Nvim-tree
require('nvim-tree').setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

-- LSP setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'pyright' }
})

-- Cấu hình capabilities cho LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Gộp các cài đặt LSP chung
local function on_attach(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Cấu hình LSP servers
require('lspconfig').clangd.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm"
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = function()
    return vim.fn.getcwd()
  end,
  init_options = {
    compilationDatabasePath = "build"
  }
}
require('lspconfig').pyright.setup{
  capabilities = capabilities,
  on_attach = on_attach
}

-- Cấu hình Gitsigns
require('gitsigns').setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})

-- Thêm keymaps cho Gitsigns
local gs = package.loaded.gitsigns

vim.keymap.set('n', ']c', gs.next_hunk)
vim.keymap.set('n', '[c', gs.prev_hunk)
vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
vim.keymap.set('n', '<leader>hb', gs.blame_line)

-- Các phím tắt khác
vim.keymap.set('n', '<leader>hS', gs.stage_buffer)
vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk)
vim.keymap.set('n', '<leader>hR', gs.reset_buffer)
vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
vim.keymap.set('n', '<leader>hd', gs.diffthis)
vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)

-- Cấu hình nvim-cmp đơn giản với style mặc định
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true}),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- Lualine
require('lualine').setup()

-- Autopairs
require('nvim-autopairs').setup()

-- Cấu hình hiển thị diagnostic
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- Thay đổi các biểu tượng diagnostic
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Cấu hình Trouble
require("trouble").setup {
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = {"<cr>", "<tab>"},
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = {"o"},
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = {"zM", "zm"},
        open_folds = {"zR", "zr"},
        toggle_fold = {"zA", "za"},
        previous = "k",
        next = "j"
    },
    indent_lines = true,
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = false
}

-- Phím tắt cho Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  {silent = true, noremap = true}
)

-- Hiển thị diagnostic khi di chuyển con trỏ
vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- Cấu hình rainbow-delimiters
local rainbow_delimiters = require('rainbow-delimiters')
require('rainbow-delimiters.setup').setup {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

-- Cấu hình Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 
        "c", 
        "lua", 
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    }
}

-- Cấu hình màu sắc chung với autocmd
vim.api.nvim_create_autocmd({"ColorScheme", "FileType", "BufEnter"}, {
    pattern = "*",
    callback = function()
        vim.cmd([[
            highlight Keyword guifg=#C678DD gui=italic
            highlight StorageClass guifg=#C678DD
            highlight Operator guifg=#56B6C2
            highlight Type guifg=#E5C07B
            highlight PreProc guifg=#E06C75
            highlight String guifg=#98C379
            highlight Character guifg=#98C379
            highlight Number guifg=#D19A66
            highlight Boolean guifg=#D19A66
            highlight Constant guifg=#61AFEF
            highlight Comment guifg=#5C6370 gui=italic
            highlight Identifier guifg=#E06C75
            highlight Function guifg=#61AFEF
            
            " Thêm highlight đặc biệt cho service status
            highlight ServiceReady guifg=#98C379 gui=bold
            highlight ServiceError guifg=#E06C75 gui=bold
        ]])
    end,
    group = vim.api.nvim_create_augroup("CustomHighlights", { clear = true })
})

-- Cấu hình mini.indentscope
require('mini.indentscope').setup({
    symbol = "│",
    options = { 
        try_as_border = true,
        border = 'both',
    },
    draw = {
        animation = require('mini.indentscope').gen_animation.none()
    }
})

-- Cấu hình Floaterm
vim.g.floaterm_shell = 'pwsh'
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_position = 'center'
vim.g.floaterm_borderchars = '─│─│╭╮╯╰'

-- Phím tắt cho Floaterm
vim.keymap.set('n', '<leader>ft', ':FloatermToggle<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:FloatermToggle<CR>')
vim.keymap.set('n', '<leader>fn', ':FloatermNew<CR>')
vim.keymap.set('n', '<leader>fp', ':FloatermPrev<CR>')
vim.keymap.set('n', '<leader>fk', ':FloatermKill<CR>')

-- Cấu hình Telescope
local telescope = require('telescope')
telescope.setup{
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      }
    }
  }
}
-- Phím tắt cho Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

-- Cấu hình Which Key
require("which-key").setup{}

-- Cấu hình TypeScript/JavaScript LSP và Completion
require('typescript-tools').setup({
    settings = {
        -- Cấu hình cho TypeScript
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithObjectLiteralMethodSnippets = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
            },
        },
    }
})

-- Cấu hình Treesitter cho JavaScript/TypeScript
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

-- Thêm snippets cho JavaScript/React
local ls = require("luasnip")
ls.add_snippets("javascript", {
    ls.snippet("clg", {
        ls.text_node("console.log("),
        ls.insert_node(1),
        ls.text_node(");")
    }),
    ls.snippet("rfc", {
        ls.text_node({"import React from 'react'", "", "const "}),
        ls.insert_node(1, "ComponentName"),
        ls.text_node({" = () => {", "  return (", "    "}),
        ls.insert_node(2, "<div>"),
        ls.text_node({"", "    "}),
        ls.insert_node(0),
        ls.text_node({"", "    </div>", "  )", "}", "", "export default "}),
        ls.dynamic_node(3, function(args)
            return ls.snippet_node(nil, {
                ls.text_node(args[1][1])
            })
        end, {1})
    }),
})

-- Cấu hình null-ls cho formatting
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            filetypes = {
                "javascript",
                "typescript",
                "javascriptreact",
                "typescriptreact",
                "css",
                "html",
                "json",
                "yaml",
                "markdown",
            },
        }),
        null_ls.builtins.formatting.black.with({
            extra_args = {"--fast"}
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c", "cpp", "h", "hpp" }
        }),
    },
})

-- Thêm autocommand để format khi save (nếu chưa có)
vim.cmd [[
    augroup FormatAutogroup
        autocmd!
        autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.py,*.lua,*.c,*.cpp,*.h lua vim.lsp.buf.format()
    augroup END
]]

-- Thêm keymap format thủ công (nếu chưa có)
vim.keymap.set('n', '<leader>fm', function()
    vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true })

-- Auto format khi save
vim.cmd [[autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx lua vim.lsp.buf.format()]]

-- Thêm keymaps cho TypeScript
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
    callback = function()
        local opts = { noremap=true, silent=true, buffer=true }
        vim.keymap.set('n', 'gD', '<cmd>TypescriptGoToSourceDefinition<cr>', opts)
        vim.keymap.set('n', '<leader>tr', '<cmd>TypescriptRenameFile<cr>', opts)
        vim.keymap.set('n', '<leader>ti', '<cmd>TypescriptOrganizeImports<cr>', opts)
        vim.keymap.set('n', '<leader>tf', '<cmd>TypescriptFixAll<cr>', opts)
    end,
})

-- Cấu hình LSP cơ bản cho HTML/CSS
require('lspconfig').html.setup({
    capabilities = capabilities,
    filetypes = { "html" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true
        },
        provideFormatter = true
    },
    settings = {
        html = {
            format = {
                enable = true,
            },
            hover = {
                documentation = true,
                references = true,
            },
            completion = {
                enable = true,
                attributeDefaultValue = "doublequotes"
            },
            validate = {
                scripts = true,
                styles = true,
            },
            suggest = {
                html5 = true,
            },
        },
    },
})

require('lspconfig').cssls.setup({
    capabilities = capabilities
})

-- Cấu hình Treesitter cho HTML/CSS
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "html",
        "css"
    },
    highlight = {
        enable = true
    },
    autotag = {
        enable = true,
    }
}

-- Cấu hình luasnip cho snippets
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

-- Cấu hình nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    experimental = {
        ghost_text = true,
    },
})

-- Live Server với npm live-server
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html", "css", "javascript"},
    callback = function()
        -- Bắt đầu live server
        vim.keymap.set('n', '<leader>ll', function()
            vim.cmd('w')  -- Lưu file trước
            vim.cmd('FloatermNew --name=liveserver live-server --port=3000')
        end, {
            noremap = true,
            buffer = true,
            desc = "Start Live Server"
        })
        
        -- Tắt live server
        vim.keymap.set('n', '<leader>ls', function()
            vim.cmd('FloatermKill liveserver')
        end, {
            noremap = true,
            buffer = true,
            desc = "Stop Live Server"
        })

        -- Toggle terminal live server
        vim.keymap.set('n', '<leader>lt', function()
            vim.cmd('FloatermToggle liveserver')
        end, {
            noremap = true,
            buffer = true,
            desc = "Toggle Live Server terminal"
        })
    end
})

-- Cấu hình clangd_extensions
require("clangd_extensions").setup({
    server = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders"
        }
    }
})

-- Cấu hình cmake-tools
require("cmake-tools").setup({
    cmake_command = "cmake",
    cmake_build_directory = "build",
    cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" }
})

-- Cấu hình notify
require("notify").setup({
    background_colour = "#000000",
    timeout = 3000,
    max_width = 80
})

-- Cấu hình hop
require('hop').setup()
vim.keymap.set('n', 'f', "<cmd>lua require'hop'.hint_char1()<cr>", {})
vim.keymap.set('n', 'F', "<cmd>lua require'hop'.hint_words()<cr>", {})

-- Cấu hình git-conflict
require('git-conflict').setup({
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
})

-- Cấu hình toggleterm
require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 3,
    }
})

-- Cấu hình nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
})

-- Cấu hình dressing.nvim
require('dressing').setup({
    input = {
        enabled = true,
        default_prompt = "➤ ",
        prompt_align = "left",
        insert_only = true,
        border = "rounded",
        relative = "cursor",
    },
    select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        trim_prompt = true,
    },
})


-- Live Server với npm live-server
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html", "css", "javascript"},
    callback = function()
        -- Bắt đầu live server
        vim.keymap.set('n', '<leader>ll', function()
            vim.cmd('w')  -- Lưu file trước
            vim.cmd('FloatermNew --name=liveserver live-server --port=3000')
        end, {
            noremap = true,
            buffer = true,
            desc = "Start Live Server"
        })
        
        -- Tắt live server
        vim.keymap.set('n', '<leader>ls', function()
            vim.cmd('FloatermKill liveserver')
        end, {
            noremap = true,
            buffer = true,
            desc = "Stop Live Server"
        })

        -- Toggle terminal live server
        vim.keymap.set('n', '<leader>lt', function()
            vim.cmd('FloatermToggle liveserver')
        end, {
            noremap = true,
            buffer = true,
            desc = "Toggle Live Server terminal"
        })
    end
})

-- Cấu hình clangd_extensions
require("clangd_extensions").setup({
    server = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders"
        }
    }
})

-- Cấu hình cmake-tools
require("cmake-tools").setup({
    cmake_command = "cmake",
    cmake_build_directory = "build",
    cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" }
})

-- Cấu hình notify
require("notify").setup({
    background_colour = "#000000",
    timeout = 3000,
    max_width = 80
})

-- Cấu hình hop
require('hop').setup()
vim.keymap.set('n', 'f', "<cmd>lua require'hop'.hint_char1()<cr>", {})
vim.keymap.set('n', 'F', "<cmd>lua require'hop'.hint_words()<cr>", {})

-- Cấu hình git-conflict
require('git-conflict').setup({
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
})

-- Cấu hình nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
})

-- Cấu hình dressing.nvim
require('dressing').setup({
    input = {
        enabled = true,
        default_prompt = "➤ ",
        prompt_align = "left",
        insert_only = true,
        border = "rounded",
        relative = "cursor",
    },
    select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        trim_prompt = true,
    },
})

-- Cấu hình TSC (NEW)
require('tsc').setup()

-- Thêm keymaps cho Node.js development (NEW)
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"javascript", "typescript"},
    callback = function()
        -- Chạy Node.js script
        vim.keymap.set('n', '<leader>nr', function()
            vim.cmd('w')
            vim.cmd('FloatermNew node %')
        end, {
            noremap = true,
            buffer = true,
            desc = "Run Node.js script"
        })
        
        -- NPM commands
        vim.keymap.set('n', '<leader>ni', ':FloatermNew npm install<CR>', {
            noremap = true,
            buffer = true,
            desc = "npm install"
        })
        
        vim.keymap.set('n', '<leader>ns', ':FloatermNew npm start<CR>', {
            noremap = true,
            buffer = true,
            desc = "npm start"
        })
        
        vim.keymap.set('n', '<leader>nt', ':FloatermNew npm test<CR>', {
            noremap = true,
            buffer = true,
            desc = "npm test"
        })
        
        -- Package Info commands
        vim.keymap.set('n', '<leader>pi', require('package-info').show, {
            noremap = true,
            buffer = true,
            desc = "Show package info"
        })
    end
})
