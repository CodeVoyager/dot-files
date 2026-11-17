-- Neovim config. Plugins live in lua/plugins/ (lazy.nvim).

-- No remote plugins need Python any more (deoplete was the only one)
vim.g.loaded_python3_provider = 0

-- General

vim.opt.clipboard:append("unnamedplus")
vim.opt.spell = true
vim.opt.spelllang = "en_gb"
vim.opt.scrolloff = 10

-- Redraw time

vim.opt.regexpengine = 0

-- Tabs

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line numbers

vim.opt.number = true -- Show current line number
vim.opt.relativenumber = true -- Show relative line numbers

-- Line wrap
vim.opt.wrap = true

-- Plugins

-- Neovim would turn these on only after this file, so its syntax autocmd
-- would run after the plugins' FileType autocmds and wipe their syntax rules
-- (e.g. vim-devicons hiding the [ ] around NERDTree icons).
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
require("config.lazy")

-- Remaps

local map = vim.keymap.set

-- Quick escape
map('i', 'jk', '<Esc>')

-- NERDTree

map("n", "<leader>n", ":NERDTreeFocus<CR>")
map("n", "<C-e>", ":NERDTree<CR>")
map("n", "<C-t>", ":NERDTreeToggle<CR>")
map("n", "<C-f>", ":NERDTreeFind<CR>")

-- File search (<Plug> targets are mappings themselves, so these must remap)

map("n", "<C-F>f", "<Plug>CtrlSFPrompt", { remap = true })
map("n", "<C-F>n", "<Plug>CtrlSFCwordPath", { remap = true })
map("n", "<C-F>p", "<Plug>CtrlSFPwordPath", { remap = true })

-- Fuzzy finder keys (<C-P>, <C-F>z, <leader>f…) are in lua/plugins/picker.lua

-- LSP (vtsls) for definitions; vim.diagnostic jumps cover both LSP errors
-- and ALE's eslint errors

map("n", "<C-F>g", function()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
end, { desc = "Go to definition in a vertical split" })
map("n", "<leader>aj", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>ak", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

-- Resizes

map("n", "<C-R>f", ":vertical resize 100<CR>")
map("n", "<C-R>c", ":vertical resize 5<CR>")
map("n", "<C-R>n", ":vertical resize ") -- left open to type the width

-- Auto commands

local nerdtree = vim.api.nvim_create_augroup("nerdtree_auto", { clear = true })

-- Open NERDTree on start, then move back to the file window
vim.api.nvim_create_autocmd("VimEnter", { group = nerdtree, command = "NERDTree" })
vim.api.nvim_create_autocmd("VimEnter", { group = nerdtree, command = "wincmd l" })

-- Quit when NERDTree is the last window left
vim.api.nvim_create_autocmd("BufEnter", {
  group = nerdtree,
  command = "if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif",
})

-- Colorscheme

vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.cmd.colorscheme("ayu")
-- vim.cmd.colorscheme("tokyonight-storm")

-- Neovide

if vim.g.neovide then
  vim.o.guifont = "BlexMono Nerd Font Mono:h14"
  -- vim.o.guifont = "Fira Code:h14"

  vim.g.neovide_opacity = 0.9

  vim.g.neovide_refresh_rate = 40
  vim.g.neovide_refresh_rate_idle = 5

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.5
  vim.g.neovide_cursor_vfx_particle_density = 5

  vim.g.sonokai_style = "maia"
  vim.g.sonokai_better_performance = 0
  vim.g.sonokai_diagnostic_virtual_text = "highlighted"

  vim.cmd.colorscheme("sonokai")

  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#78CEE9", bold = false })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#E1E2E3", bold = false })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#F76C7C", bold = false })
end

-- Statusline (set up after the colorscheme: "auto" follows whichever one is active)

require("lualine").setup({
  options = {
    theme = "auto",
  },
})
