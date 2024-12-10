-- git lens 
return {
    {
      "tpope/vim-fugitive",
      cmd = { "G", "Git" },
      keys = {
        { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
        { "<leader>ga", "<cmd>Git add .<cr>", desc = "Git add all" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      },
    },
    {
      "kdheepak/lazygit.nvim",
      keys = {
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
  }
  
