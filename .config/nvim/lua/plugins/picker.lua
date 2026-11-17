-- Fuzzy picker: fzf-lua with the "telescope" profile (Telescope's look and keys).
-- Uses the fzf and rg binaries from Homebrew.
return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- load at startup so vim.ui.select (code actions via gra) uses fzf-lua
    -- from the first call; fzf-lua itself loads its pickers lazily
    lazy = false,
    opts = {
      "telescope",
      -- <C-x>/<C-v>/<C-t> open in split/vsplit/tab, <C-q> sends all to quickfix
      -- (from the profile); <Tab> marks several items
    },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      -- vim.ui.select (code actions, etc.) uses the fzf-lua picker
      fzf.register_ui_select()
    end,
    keys = {
      -- my existing file-search keys
      { "<C-P>", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<C-F>z", "<cmd>FzfLua files<CR>", desc = "Find files" },
      -- Telescope-style <leader>f… keys
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
      { "<leader>fw", "<cmd>FzfLua grep_visual<CR>", mode = "x", desc = "Grep selection" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
      { "<leader>f/", "<cmd>FzfLua blines<CR>", desc = "Search current buffer" },
      { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
      { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
      { "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Resume last picker" },
      { "<leader>fp", "<cmd>FzfLua builtin<CR>", desc = "All pickers" },
      -- LSP / diagnostics
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fR", "<cmd>FzfLua lsp_references<CR>", desc = "LSP references" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics (file)" },
      { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Diagnostics (workspace)" },
      -- git
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Git status" },
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Git commits" },
      { "<leader>gb", "<cmd>FzfLua git_branches<CR>", desc = "Git branches" },
    },
  },
}
