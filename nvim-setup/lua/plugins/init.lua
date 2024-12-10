-- Cài đặt Packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
end
  
local packer_bootstrap = ensure_packer()
  
return require('packer').startup(function(use)
    -- Quản lý plugin
    use 'wbthomason/packer.nvim'
  
    -- UI & Theme
    use 'navarasu/onedark.nvim'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons' }
    }
    use { 'echasnovski/mini.indentscope', branch = 'stable' }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'HiPhish/rainbow-delimiters.nvim'

    -- File explorer & Search
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' }
    }
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep'
      }
    }
    
    -- LSP & Completion
    use {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/lsp-colors.nvim'
    }
    use {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    }
    
    -- Debug
    use {
      'nvim-neotest/nvim-nio',
    }
    use {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      after = 'nvim-nio'
    }

    -- Code helpers
    use 'windwp/nvim-autopairs'
    use 'simrat39/symbols-outline.nvim'
    use {
      'numToStr/Comment.nvim',
      config = function() require('Comment').setup() end
    }
    
    -- Git
    use {
      'lewis6991/gitsigns.nvim',
      config = function() require('gitsigns').setup() end
    }

    -- Syntax & Language support
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    
    -- Python specific
    use 'Vimjas/vim-python-pep8-indent'
    use {
        'numirias/semshi',
        run = ':UpdateRemotePlugins',
        ft = 'python'
    }
    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }

    -- Utils
    use 'voldikss/vim-floaterm'
    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end
    }
    use {
      "folke/trouble.nvim",
      requires = "nvim-tree/nvim-web-devicons",
    }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim"
    }

    -- LSP Enhancements
    use {
        'ray-x/lsp_signature.nvim',
    }

    -- Web Development
    use {
      'pmizio/typescript-tools.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' }
    }
    use {
      'windwp/nvim-ts-autotag',
      ft = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
    }
    use {
      'norcalli/nvim-colorizer.lua',
      config = function() 
        require('colorizer').setup() 
      end
    }
    use {
      'mattn/emmet-vim',
      ft = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
    }
    use {
        'mlaursen/vim-react-snippets',
        ft = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}
    }
    use {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        config = function()
            require('tailwindcss-colorizer-cmp').setup()
        end
    }
    use {
        'barrett-ruth/live-server.nvim',
        config = function()
            require('live-server').setup({
                port = 3000,
                browser_command = 'chrome',
                quiet = false,
                no_css_inject = false,
                install_path = vim.fn.stdpath('config') .. '/live-server-install',
            })
        end
    }

    -- Thêm các plugin mới cho C/C++
    use 'p00f/clangd_extensions.nvim'
    use 'Civitasv/cmake-tools.nvim'
    use 'jakemason/ouroboros.nvim'

    -- Thêm các plugin mới cho Python
    use 'HallerPatrick/py_lsp.nvim'

    -- Thêm các plugin mới cho Web Development
    use 'MaxMEllon/vim-jsx-pretty'
    use 'davidgranstrom/nvim-markdown-preview'

    -- Thêm các công cụ cốt lõi mới
    use 'stevearc/dressing.nvim'
    use 'rcarriga/nvim-notify'
    use {
        'phaazon/hop.nvim',
        branch = 'v2'
    }
    use {
        'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }
    use 'akinsho/git-conflict.nvim'
    use {
        'akinsho/toggleterm.nvim',
        tag = '*'
    }

    -- Debug Enhancement
    use 'theHamsta/nvim-dap-virtual-text'

    use {
        'vuki656/package-info.nvim',
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('package-info').setup()
        end
    }

    use {
        'dmmulroy/tsc.nvim',
    }

    use {
        'pantharshit00/vim-prisma',
    }

    use {
        'folke/neodev.nvim',
    }

    -- Thêm Rust support
    use {
        'simrat39/rust-tools.nvim',
        requires = {'neovim/nvim-lspconfig'},
    }
    use 'saecki/crates.nvim'

    -- Thêm Go support
    use {
        'ray-x/go.nvim',
        requires = {'ray-x/guihua.lua'},
    }

    -- Framework specific
    use {
        'folke/noice.nvim',
        requires = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        }
    }
    use {
        'kevinhwang91/nvim-ufo',
        requires = 'kevinhwang91/promise-async'
    }

    -- GraphQL support
    use {
        'jparise/vim-graphql',
        ft = {'graphql', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact'}
    }

    -- Database tools
    use {
        'tpope/vim-dadbod',
        requires = {
            'kristijanhusak/vim-dadbod-ui',
            'kristijanhusak/vim-dadbod-completion',
        }
    }

    -- Backend Testing & Debugging
    use {
        'nvim-neotest/neotest',
        requires = {
            'nvim-neotest/neotest-python',  -- Python testing
            'haydenmeade/neotest-jest',     -- JavaScript testing
            'rouge8/neotest-rust',          -- Rust testing
        }
    } 

    -- API Development
    use {
        'gennaro-tedesco/nvim-jqx',        -- JSON viewer
        'chentoast/marks.nvim',            -- Better marks visualization
    }

    -- Project Management
    use {
        'ahmedkhalf/project.nvim',
        config = function()
            require("project_nvim").setup()
        end
    }
    
    -- Session Management
    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup()
        end
    }
    
    -- Better Code Navigation
    use {
        'pechorin/any-jump.nvim'
    }
    
    -- Code Metrics & Stats
    use {
        'David-Kunz/jester',  -- Testing framework
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter'
        }
    }
    
    use {
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
    }

    -- Advanced Git Operations
    use {
        'NeogitOrg/neogit',
        requires = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim'
        }
    }

    if packer_bootstrap then
      require('packer').sync()
    end
end)
  
