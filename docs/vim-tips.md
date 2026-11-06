# Neovim tips (my setup)

Set up 2026-11-06: lazy.nvim + blink.cmp + vtsls (TypeScript LSP) + ALE (eslint/prettier).

## Completion (blink.cmp)

| Key         | Action                           |
| ----------- | -------------------------------- |
| `<C-space>` | Open the menu / show docs        |
| `<C-n>`     | Next item (also `<Down>`)        |
| `<C-p>`     | Previous item (also `<Up>`)      |
| `<C-y>`     | Accept                           |
| `<C-e>`     | Close                            |
| `<C-k>`     | Toggle function signature help   |

Sources: LSP, file paths, snippets (friendly-snippets), buffer words.
Rather accept with Tab or Enter? Change `keymap = { preset = "default" }` in
`lua/plugins/completion.lua` to `"super-tab"` or `"enter"`.

## LSP (Neovim 0.11 built-in keys)

| Key       | Action                                   |
| --------- | ---------------------------------------- |
| `K`       | Hover docs                               |
| `<C-]>`   | Go to definition                         |
| `<C-o>`   | **Back from the definition** (`<C-i>` forward again) |
| `<C-F>g`  | Definition in a vertical split (my map)  |
| `grn`     | Rename symbol                            |
| `gra`     | Code actions                             |
| `grr`     | References                               |
| `gri`     | Implementations                          |
| `grt`     | Type definition                          |
| `gO`      | Document symbols                         |
| `<C-s>`   | Signature help (insert mode)             |

`<C-t>` would normally also jump back, but in my setup it toggles NERDTree.
`:pop` does the same job. Full guide in the next section.

## LSP navigation in depth

Docs inside Neovim: `:help lsp-defaults` (the keys below), `:help lsp-buf`
(every LSP action), `:help jumplist`, `:help tagstack`, `:help quickfix`.
Online: <https://neovim.io/doc/user/lsp.html>.

### Jumping to code

| Key / command                          | Goes to                                         |
| -------------------------------------- | ----------------------------------------------- |
| `<C-]>`                                | Definition of the word under the cursor         |
| `<C-F>g`                               | Definition, opened in a new vertical split      |
| `grt`                                  | Type definition (e.g. the interface of a variable) |
| `gri`                                  | Implementations (of an interface / abstract method) |
| `:lua vim.lsp.buf.declaration()`       | Declaration (no default key)                    |

If there's exactly one target, Neovim jumps there. If there are several, it
opens the **quickfix list** at the bottom (see below).

### Going back (and forward again)

Every LSP jump goes on two stacks, so there are two ways back:

| Key / command   | Stack     | Action                                            |
| --------------- | --------- | ------------------------------------------------- |
| `<C-o>`         | jumplist  | Back to where you were (works for any big jump: LSP, search, `G`, `%`…) |
| `<C-i>` / `Tab` | jumplist  | Forward again                                     |
| `:pop`          | tag stack | Back one definition jump only (what `<C-t>` normally does) |
| `:tags`         | tag stack | Show the chain of definition jumps                |
| `:jumps`        | jumplist  | Show the whole jump history                       |

Tip: `<C-o>` several times walks back through a chain of `<C-]>` jumps.
After `<C-F>g` you're in a new split, so "going back" is just closing it:
`<C-w>c` (or `:q`).

### Finding usages and symbols

| Key / command                              | Shows                                    |
| ------------------------------------------ | ---------------------------------------- |
| `grr`                                      | Every reference to the symbol (quickfix list) |
| `gO`                                       | Outline of the current file (location list) |
| `:lua vim.lsp.buf.workspace_symbol()`      | Search symbols across the project        |
| `:lua vim.lsp.buf.incoming_calls()`        | Who calls this function                  |
| `:lua vim.lsp.buf.outgoing_calls()`        | What this function calls                 |

Same things in the fuzzy picker (filter as you type, with a preview), see
[Finding things](#finding-things-fzf-lua-telescope-style):

| Key           | Picker                                     |
| ------------- | ------------------------------------------ |
| `<leader>fR`  | References                                 |
| `<leader>fs`  | Symbols in this file                       |
| `<leader>fS`  | Symbols in the whole project (live search) |
| `<leader>fd` / `<leader>fD` | Problems in this file / project |
| `:FzfLua lsp_finder` | Definitions, references, implementations… in one list |
| `:FzfLua lsp_incoming_calls` | Who calls this function           |

### Moving through result lists

`grr`, `gri` and multi-target jumps fill the **quickfix list**; `gO` fills the
**location list** (per window).

| Key            | Action                                   |
| -------------- | ---------------------------------------- |
| `]q` / `[q`    | Next / previous quickfix item            |
| `]l` / `[l`    | Next / previous location-list item       |
| `Enter`        | (inside the list) jump to that item      |
| `:copen` / `:cclose` | Open / close the quickfix window   |
| `:lopen` / `:lclose` | Open / close the location list     |
| `:colder` / `:cnewer` | Previous / next quickfix list (earlier searches) |

### Reading without jumping

| Key       | Action                                                          |
| --------- | --------------------------------------------------------------- |
| `K`       | Hover: type + docs. Press `K` again to move into the popup, `q` to close |
| `<C-s>`   | (insert mode) function signature while typing arguments         |
| `<C-w>d`  | The error / warning under the cursor                            |
| `]d` `[d` | Next / previous problem                                         |

### Changing code

| Key   | Action                                                       |
| ----- | ------------------------------------------------------------ |
| `grn` | Rename the symbol everywhere (all files)                     |
| `gra` | Code actions: quick fixes, add missing import, organize imports… (opens in the fzf-lua picker) |

### When it doesn't work

- `:LspInfo` (or `:checkhealth vim.lsp`): is vtsls attached to this buffer?
- vtsls needs a project root: a lockfile (`package-lock.json`, `yarn.lock`,
  `pnpm-lock.yaml`, `bun.lock`) or `.git`; otherwise it uses the current
  directory.
- `~/.local/state/nvim/lsp.log`: server errors.

## Errors / diagnostics (TypeScript + eslint together)

| Key           | Action                               |
| ------------- | ------------------------------------ |
| `]d` / `[d`   | Next / previous problem              |
| `<leader>aj`  | Next problem + popup (my map)        |
| `<leader>ak`  | Previous problem + popup (my map)    |
| `<C-w>d`      | Show the problem under the cursor    |

Leader is the default `\`.

## ALE (eslint + prettier)

- `:ALEFix` runs the fixers (prettier, eslint, trailing whitespace). Not on save.
- `:ALEInfo` shows which linters/fixers run for the current file.
- Uses the project's own `node_modules` eslint/prettier first.

## Tags (nvim-ts-autotag)

Typing `<div>` in HTML/JSX/TSX adds `</div>`; renaming an opening tag renames
the closing one.

## Moving between splits and tmux panes (vim-tmux-navigator)

| Key     | Action                                                   |
| ------- | -------------------------------------------------------- |
| `<C-h>` | Split / tmux pane to the left                            |
| `<C-j>` | Split / tmux pane below                                  |
| `<C-k>` | Split / tmux pane above                                  |
| `<C-l>` | Split / tmux pane to the right                           |
| `<C-\>` | Previous split / pane                                    |

At the edge of Neovim the same key carries on into the next tmux pane, and
from a tmux pane back into Neovim. Gotchas:
- Inside the NERDTree window, `<C-j>`/`<C-k>` jump between sibling folders
  instead. Use `<C-l>` to leave NERDTree.
- `<C-l>` no longer redraws or clears search highlighting; use `:nohlsearch` (`:noh`).

## Finding things (fzf-lua, Telescope-style)

fzf-lua with its `telescope` profile: Telescope's look and keys on top of fzf.
Leader is `\`, so `<leader>ff` means `\` `f` `f`.

| Key                  | Picker                                      |
| -------------------- | ------------------------------------------- |
| `<C-P>` / `<C-F>z` / `<leader>ff` | Files                          |
| `<leader>fg`         | Live grep (ripgrep) across the project      |
| `<leader>fw`         | Grep the word under cursor (or the visual selection) |
| `<leader>f/`         | Search lines in the current file            |
| `<leader>fb`         | Open buffers (`<C-d>` inside closes one)    |
| `<leader>fo`         | Recently opened files                       |
| `<leader>fr`         | **Resume** the last picker, query and position kept |
| `<leader>fh`         | Neovim help                                 |
| `<leader>fk`         | Keymaps (find "what's bound to…")           |
| `<leader>fc`         | Commands                                    |
| `<leader>fp`         | List of all pickers                         |
| `<leader>gs` / `gc` / `gb` | Git status / commits / branches       |
| `<leader>fs` `fS` `fR` `fd` `fD` | LSP pickers, see [LSP navigation](#finding-usages-and-symbols) |

Anything else: `:FzfLua <Tab>` lists every picker (e.g. `:FzfLua git_blame`,
`:FzfLua undotree`, `:FzfLua marks`, `:FzfLua registers`).

### Inside a picker

| Key                     | Action                                        |
| ----------------------- | --------------------------------------------- |
| type                    | Filter (fzf syntax, below)                    |
| `<C-j>`/`<C-k>`, `<C-n>`/`<C-p>`, arrows | Move down / up               |
| `Enter`                 | Open (several marked → quickfix list)         |
| `<C-v>` / `<C-x>` / `<C-t>` | Open in vertical split / split / new tab  |
| `Tab` / `Shift-Tab`     | Mark / unmark several items                   |
| `<C-q>`                 | Send **all** results to the quickfix list     |
| `<C-d>` / `<C-u>`       | Scroll the preview down / up                  |
| `<F4>`                  | Toggle the preview                            |
| `<F2>`                  | Toggle fullscreen                             |
| `<F1>`                  | Show all keys for this picker                 |
| `Esc` / `<C-c>`         | Close                                         |

Search syntax: `word` fuzzy, `'word` exact, `^src` starts with, `.tsx$` ends
with, `!test` excludes; spaces combine terms (`^src screen .tsx$`), and `|`
means OR.

Gotchas:
- `alt-…` keys (e.g. `alt-q` "marked to quickfix", `alt-a` "toggle all") need
  Option to act as Alt, which my Alacritty doesn't do yet (see tmux tips). Use
  `Tab` + `Enter` or `<C-q>` instead.
- File search uses ripgrep (`fd` isn't installed), so it respects `.gitignore`.
- Plain Vim still has `:FZF` on `<C-P>`.

## Other mappings from ~/.vimrc

| Key                    | Action                    |
| ---------------------- | ------------------------- |
| `<C-F>f`               | CtrlSF search prompt      |
| `<C-F>n` / `<C-F>p`    | CtrlSF word / pword       |
| `<leader>n`            | Focus NERDTree            |
| `<C-t>`                | Toggle NERDTree (replaces Vim's "back from tag") |
| `<C-e>`                | Open NERDTree             |
| `<C-f>`                | Find current file in NERDTree |
| `<C-R>f` / `<C-R>c`    | Resize split to 100 / 5   |

## Plugins & maintenance

| Command               | What                                     |
| --------------------- | ---------------------------------------- |
| `:Lazy`               | Plugin manager UI                        |
| `:Lazy sync`          | Install + update + clean plugins         |
| `:Mason`              | Language servers / tools UI              |
| `:TSUpdate`           | Update treesitter parsers                |
| `:checkhealth`        | Diagnose problems (`:checkhealth vim.lsp`) |
| `:LspInfo`            | Which LSP clients are attached            |

## Where things live

- `~/.config/nvim/init.vim`: sources `~/.vimrc` (shared with plain Vim)
- `~/.vimrc`: options, keymaps, colorscheme; calls `require("config.lazy")` in Neovim
- `~/.config/nvim/lua/config/lazy.lua`: lazy.nvim bootstrap
- `~/.config/nvim/lua/plugins/init.lua`: most plugins (NERDTree, ALE, treesitter, vim-tmux-navigator, themes…)
- `~/.config/nvim/lua/plugins/picker.lua`: fzf-lua (Telescope profile + keys)
- `~/.config/nvim/lua/plugins/completion.lua`: blink.cmp
- `~/.config/nvim/lua/plugins/lsp.lua`: mason + vtsls
- `~/.local/share/nvim/lazy/`: installed plugins
- `~/.local/share/nvim/mason/`: installed language servers
- Plain Vim still uses vim-plug (`~/.vim/autoload/plug.vim`)

## Gotchas

- vtsls runs on whichever Node nvm has active in the shell that starts Neovim.
- nvim-treesitter is pinned to `master`; `main` is an incompatible rewrite.
- `Command setContext not found` in `~/.local/state/nvim/lsp.log` is harmless vtsls noise.
- Backups from the migration: `~/.vimrc.bak-pre-lazy`, `~/.config/nvim/init.vim.bak`.
