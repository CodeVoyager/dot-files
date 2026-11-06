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

if has('nvim')
  " Neovim: plugins are managed by lazy.nvim (~/.config/nvim/lua/plugins/)
  lua require("config.lazy")
else
  call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-fugitive'
    Plug 'leafgarland/typescript-vim'
    Plug 'quramy/tsuquyomi'
  call plug#end()
endif

" Remaps
" NERDTree

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-e> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" File search
if has('nvim')
  nmap     <C-F>f <Plug>CtrlSFPrompt
  nmap     <C-F>n <Plug>CtrlSFCwordPath
  nmap     <C-F>p <Plug>CtrlSFPwordPath
" let g:ctrlsf_debug_mode = 1
endif


" FZF (Neovim uses fzf-lua instead: ~/.config/nvim/lua/plugins/picker.lua)

if !has('nvim')
  nmap <C-F>z :FZF<CR>
  nmap <C-P> :FZF<CR>
endif

" ALE
if has('nvim')
  " Neovim LSP (vtsls) for definitions; vim.diagnostic jumps cover both
  " LSP errors and ALE's eslint errors
  nmap     <C-F>g <C-w>v<cmd>lua vim.lsp.buf.definition()<CR>
  nmap <silent> <leader>aj <cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>
  nmap <silent> <leader>ak <cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>
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
  let g:neoformat_try_node_exe = 1
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
