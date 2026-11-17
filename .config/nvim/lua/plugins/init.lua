-- Neovim plugins.
-- Keymaps, NERDTree autocmds, the colorscheme and Neovide settings are in init.lua;
-- it calls require("config.lazy") before them, so everything below is on the
-- runtimepath by the time the rest of init.lua runs.
return {
  -- File tree
  { "preservim/nerdtree" },
  { "Xuyuanp/nerdtree-git-plugin", dependencies = { "preservim/nerdtree" } },
  -- vim-devicons must load after the plugins it decorates
  {
    "ryanoasis/vim-devicons",
    dependencies = { "preservim/nerdtree" },
    config = function(plugin)
      -- NERDTree sources nerdtree_plugin/*.vim only once, when it loads itself.
      -- lazy.nvim adds vim-devicons to the runtimepath after that, so its
      -- NERDTree hook never runs and the tree shows no icons. Source it here.
      vim.cmd.source(plugin.dir .. "/nerdtree_plugin/webdevicons.vim")
    end,
  },

  -- Search / navigation
  { "easymotion/vim-easymotion" },
  {
    -- C-h/j/k/l move between Neovim splits and on into tmux panes
    -- (tmux side: @plugin in ~/.config/tmux/tmux.conf)
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>", desc = "Window/pane left" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>", desc = "Window/pane down" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>", desc = "Window/pane up" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", desc = "Window/pane right" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>", desc = "Previous window/pane" },
    },
  },
  {
    "dyng/ctrlsf.vim",
    init = function()
      vim.g.ctrlsf_backend = "rg"
    end,
  },

  -- Git
  { "tpope/vim-fugitive" },

  -- Languages / completion / linting
  { "leafgarland/typescript-vim" },
  {
    -- ALE only lints and fixes with eslint/prettier; TypeScript itself is
    -- handled by Neovim's LSP (vtsls, see lsp.lua) and completion by blink.cmp.
    "dense-analysis/ale",
    init = function()
      vim.g.ale_disable_lsp = 1 -- skip tsserver and LSP linters (vtsls covers them)
      vim.g.ale_completion_enabled = 0 -- blink.cmp does completion
      vim.g.ale_linters = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
      }
      vim.g.ale_fixers = {
        ["*"] = { "remove_trailing_lines", "trim_whitespace" },
        json = { "prettier", "eslint" },
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
      }
      -- 0 = use the project's node_modules/.bin/eslint, falling back to a global one
      vim.g.ale_javascript_eslint_use_global = 0
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- `main` is an incompatible rewrite (no nvim-treesitter.configs); stay on master
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true, disable = {} },
        indent = { enable = true, disable = {} },
        ensure_installed = {
          "tsx",
          "typescript",
          "javascript",
          "json",
          "yaml",
          "css",
          "html",
          "markdown",
          "lua",
        },
      })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
    end,
  },

  -- Auto-close / auto-rename HTML and JSX tags (uses treesitter)
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- UI
  { "norcalli/nvim-colorizer.lua" },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-tree/nvim-web-devicons" },

  -- Colorschemes (load first so `colorscheme` in init.lua works)
  { "folke/tokyonight.nvim", branch = "main", priority = 1000 },
  { "ayu-theme/ayu-vim", priority = 1000 },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "rafamadriz/neon", priority = 1000 },
  { "sainnhe/sonokai", priority = 1000 },
  { "sainnhe/everforest", priority = 1000 },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'deep'
      }
    end
  }
}
