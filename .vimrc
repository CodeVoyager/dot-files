" General

set encoding=utf-8
set clipboard+=unnamedplus
setlocal spell spelllang=en_gb

" Redraw time

set re=0

" Tabs

set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Line numbers

set number                     " Show current line number
set relativenumber             " Show relative line numbers

" Plugins

call plug#begin()
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'easymotion/vim-easymotion'
  Plug 'tpope/vim-fugitive'
  Plug 'leafgarland/typescript-vim'

  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'dense-analysis/ale'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
"   Plug 'sbdchd/neoformat'
    Plug 'dyng/ctrlsf.vim'
    

    Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
    Plug 'ayu-theme/ayu-vim'
    Plug 'rafamadriz/neon'
    Plug 'sainnhe/sonokai'
  else
    Plug 'quramy/tsuquyomi'
  endif
call plug#end()

" Remaps
" NERDTree

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" File search
if has('nvim')
  nmap     <C-F>f <Plug>CtrlSFPrompt
" nmap     <C-F>n <Plug>CtrlSFCwordPath
" nmap     <C-F>p <Plug>CtrlSFPwordPath
  let g:ctrlsf_backend = 'rg'
" let g:ctrlsf_debug_mode = 1
endif


" FZF

nmap <C-F>z :FZF<CR>
nmap <C-P> :FZF<CR>

" ALE
if has('nvim')
  nmap     <C-F>g <C-w>v :ALEGoToDefinition<CR>
endif

" Resizes
nmap <C-R>f :vertical resize 100<CR>
nmap <C-R>c :vertical resize 5<CR>
nmap <C-R>n :vertical resize 

" Auto commands
set rtp+=~/.vim/plugged/nerdtree

" Auto start

" NERDTree
autocmd VimEnter * NERDTree 
autocmd VimEnter * wincmd l

" Auto close

" NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Colorscheme

set background=dark

" Autocomplete
if has('nvim')
  let g:deoplete#enable_at_startup = 1
  let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'json': ['prettier', 'eslint'],
    \   'javascript': ['prettier', 'eslint'],
    \   'typescript': ['prettier', 'eslint'],
    \   'typescriptreact': ['prettier', 'eslint'],
  \}
  let g:ale_javascript_eslint_use_global = 1
  let g:ale_javascript_tsserver_use_global = 1
  let g:ale_completion_enabled = 1
  let g:neoformat_try_node_exe = 1
endif


" LUA
if has('nvim')
lua <<EOF
  local status, ts = pcall(require, "nvim-treesitter.configs")

  if (not status) then return end

  ts.setup {
    highlight = {
      enable = true,
      disable = {},
    },
    indent = {
      enable = true,
      disable = {},
    },
    ensure_installed = {
      "tsx",
      "typescript",
      "javascript",
      "json",
      "yaml",
      "css",
      "html",
      "markdown",
      "lua"
    },
    autotag = {
      enable = true,
    },
  }

  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

  parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
EOF
endif

" Theme settings

if has('nvim')
  set termguicolors

" let ayucolor="dark"
" colorscheme ayu

  colorscheme tokyonight-storm
else
"  colorscheme edge
  let g:edge_style = 'neon'
  let g:edge_diagnostic_line_highlight=1
endif

" NeoVide config
if exists("g:neovide")
  set guifont=BlexMono\ Nerd\ Font\ Mono:h14
" set guifont=Fira\ Code:h14

  let g:neovide_transparency=0.9
  let g:transparency=0.9

" let g:neovide_refresh_rate = 60
" let g:neovide_refresh_rate = 50
  let g:neovide_refresh_rate = 40
  let g:neovide_refresh_rate_idle = 5

  let g:nevide_remember_window_size = v:true
  
  let g:neovide_cursor_vfx_mode = 'railgun'
  let g:neovide_cursor_vfx_particle_lifetime = 1.5
  let g:neovide_cursor_vfx_particle_density = 5

lua <<EOF
  require'lualine'.setup {
    options = {
      theme = 'sonokai'
    }
  }
EOF

  let g:sonokai_style = 'maia'
  let g:sonokai_better_performance = 0
  let g:sonokai_diagnostic_virtual_text = 'highlighted'

  colorscheme sonokai

lua <<EOF
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#78CEE9', bold=false })
  vim.api.nvim_set_hl(0, 'LineNr', { fg='#E1E2E3', bold=false })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#F76C7C', bold=false })
EOF
endif
