# Neovim tips (my setup)

Set up 2026-11-06: lazy.nvim + blink.cmp + vtsls (TypeScript LSP) + ALE (eslint/prettier).

Leader is the default `\`, so `<leader>ff` means `\` `f` `f`.

- [Files and windows](#files-and-windows): NERDTree, splits, tmux panes
- [Finding things](#finding-things): fzf-lua pickers, project-wide search (fzf-lua, CtrlSF)
- [Editing](#editing): completion, auto-closing tags
- [Code navigation (LSP)](#code-navigation-lsp): definitions, references, rename, code actions
- [Problems, linting and formatting](#problems-linting-and-formatting): diagnostics, ALE
- [Vallow (Fallow in Neovim)](#vallow-fallow-in-neovim): findings panel, search, next/prev
- [Git (IntelliJ-style)](#git-intellij-style): codediff, gitsigns, fugitive
- [Setup and maintenance](#setup-and-maintenance): plugin commands, where the config lives

## Files and windows

### File tree (NERDTree)

Opens on start, with the cursor in the file window.

| Key         | Action                                           |
| ----------- | ------------------------------------------------ |
| `<C-t>`     | Toggle NERDTree (replaces Vim's "back from tag") |
| `<C-e>`     | Open NERDTree                                    |
| `<leader>n` | Focus NERDTree                                   |
| `<C-f>`     | Find the current file in NERDTree                |

### Splits and tmux panes (vim-tmux-navigator)

| Key                                   | Action                                              |
| ------------------------------------- | --------------------------------------------------- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Split or tmux pane to the left / below / above / right |
| `<C-\>`                               | Previous split / pane                               |
| `<C-R>f` / `<C-R>c`                   | Resize the split to 100 / 5 columns                 |
| `<C-R>n`                              | Resize the split to a width you type                |

At the edge of Neovim the same key carries on into the next tmux pane, and
from a tmux pane back into Neovim. Gotchas:
- Inside the NERDTree window, `<C-j>`/`<C-k>` jump between sibling folders
  instead. Use `<C-l>` to leave NERDTree.
- `<C-l>` no longer redraws or clears search highlighting; use `:nohlsearch` (`:noh`).

## Finding things

### Pickers (fzf-lua, Telescope-style)

fzf-lua with its `telescope` profile: Telescope's look and keys on top of fzf.

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

Pickers for a specific area are listed with that area:
[symbols and references](#finding-usages-and-symbols),
[problems](#problems-linting-and-formatting) and [git](#intellij--here).

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

### Project-wide search

Two tools, both ripgrep underneath:

| Tool    | Good for                                                        |
| ------- | --------------------------------------------------------------- |
| fzf-lua | Quick "where is this?": results update as you type, preview, jump |
| CtrlSF  | A results buffer that stays open, with context lines and in-place editing |

#### fzf-lua (live grep)

| Key / command          | Action                                              |
| ---------------------- | --------------------------------------------------- |
| `<leader>fg`           | Live grep: results update as you type               |
| `<leader>fw`           | Grep the word under the cursor (or visual selection) |
| `:FzfLua grep`         | Ask for a pattern once, then fuzzy-filter its results |
| `<leader>fr`           | Resume the last search, query and position kept     |

Inside live grep (picker keys are in [Inside a picker](#inside-a-picker)):
- The query is a ripgrep pattern, not fuzzy. `<C-g>` switches between live
  grep and "grep once, then fuzzy-filter the results".
- Limit files with a glob after ` -- `: `useState -- *.tsx` or
  `foo -- !*.test.*`.
- `<C-q>` sends all matches to the quickfix list, so `:cnext`, `:cprev` and
  `:cdo` work on them.

#### CtrlSF (results window)

| Key      | Action                                                  |
| -------- | ------------------------------------------------------- |
| `<C-F>f` | Search prompt                                           |
| `<C-F>n` | Search prompt filled with the word under the cursor     |
| `<C-F>p` | Search prompt filled with the last search pattern       |

Only these three are mapped (`init.lua`); the backend is ripgrep
(`vim.g.ctrlsf_backend = "rg"` in `lua/plugins/init.lua`). The rest of the
plugin's defaults (case-smart, literal patterns, 3 lines of context, results
split on the left) are unchanged.

Commands:

| Command          | Action                                                   |
| ---------------- | -------------------------------------------------------- |
| `:CtrlSF [args]` | Search; with no pattern, uses the word under the cursor  |
| `:CtrlSFOpen`    | Reopen the results window without re-running the search  |
| `:CtrlSFToggle`  | Toggle the results window                                |
| `:CtrlSFUpdate`  | Re-run the search (needed before saving edits to a file that changed since the search) |

Arguments (before the pattern; a trailing path limits the search):

| Argument              | Meaning                                              |
| --------------------- | ---------------------------------------------------- |
| `-R`                  | Pattern is a regex (default is literal)              |
| `-I` / `-S`           | Case-insensitive / case-sensitive                    |
| `-W`                  | Whole words only                                     |
| `-A n` `-B n` `-C n`  | Lines of context after / before / around the match   |
| `-T type`             | Only files of a type (`-filetype`, like ack `--type`) |
| `-G glob`             | Only files matching a pattern (`-filematch`); backend syntax, not Vim |

Examples:
- `:CtrlSF -R -I foo.*` - case-insensitive regex search
- `:CtrlSF 'def foo():'` - quote a pattern containing spaces
- `:CtrlSF '"foobar"'` - quote a pattern containing double quotes
- `:CtrlSF -W useState src/` - whole word, only under `src/`

Keys inside the results window:

| Key                       | Action                                         |
| ------------------------- | ---------------------------------------------- |
| `<Enter>` / `o`           | Open the match in the source window            |
| `O`                       | Open and keep the results window open          |
| `<C-O>`                   | Open in a horizontal split                     |
| `t` / `T`                 | Open in a new tab (`T`: stay in results)       |
| `p` / `P`                 | Preview (`P`: move focus to the preview)       |
| `<C-J>` / `<C-K>`         | Next / previous match                          |
| `<C-N>` / `<C-P>`         | First match of next / previous file            |
| `M`                       | Switch between normal and compact view         |
| `<C-T>`                   | Jump via fzf, if installed (`<Enter>` focus, `<C-O>` open) |
| `<C-C>`                   | Stop a running search                          |
| `zc` / `zo`               | Fold / unfold results (plain Vim folds)        |
| `q`                       | Close the results window (in a preview: close the preview) |

Edit mode: the results window is editable. Change or delete lines and save
(`:w`) to write them back to the files. You can't insert new lines. If a file
changed since the search, run `:CtrlSFUpdate` first.

Not mapped yet, available from the plugin's README if wanted:

```lua
map("n", "<C-F>o", ":CtrlSFOpen<CR>")
map("n", "<C-F>t", ":CtrlSFToggle<CR>")
map("v", "<C-F>f", "<Plug>CtrlSFVwordPath", { remap = true }) -- visual selection
map("v", "<C-F>F", "<Plug>CtrlSFVwordExec", { remap = true }) -- ...and run now
```

Handy options (set in the plugin's `init` function in `lua/plugins/init.lua`):
`vim.g.ctrlsf_default_view_mode = "compact"`, `ctrlsf_auto_close`,
`ctrlsf_position` (`left`, `right`, `top`, `bottom`), `ctrlsf_winsize` (`"30%"`),
`ctrlsf_regex_pattern = 1` (regex by default), `ctrlsf_populate_qflist = 1`
(also fill the quickfix list).

## Editing

### Completion (blink.cmp)

| Key         | Action                            |
| ----------- | --------------------------------- |
| `<C-space>` | Open the menu / show docs         |
| `<C-n>`     | Next item (also `<Down>`)         |
| `<C-p>`     | Previous item (also `<Up>`)       |
| `<Tab>`     | Accept (in a snippet: next field) |
| `<S-Tab>`   | Previous snippet field            |
| `<C-e>`     | Close                             |
| `<C-k>`     | Toggle function signature help    |

Sources: LSP, file paths, snippets (friendly-snippets), buffer words.
Rather accept with `<C-y>` or Enter? Change `keymap = { preset = "super-tab" }` in
`lua/plugins/completion.lua` to `"default"` or `"enter"`.

### Tags (nvim-ts-autotag)

Typing `<div>` in HTML/JSX/TSX adds `</div>`; renaming an opening tag renames
the closing one.

## Code navigation (LSP)

These are Neovim 0.11's built-in keys unless marked "my map".
Docs inside Neovim: `:help lsp-defaults` (the keys below), `:help lsp-buf`
(every LSP action), `:help jumplist`, `:help tagstack`, `:help quickfix`.
Online: <https://neovim.io/doc/user/lsp.html>.

### Jumping to code

| Key / command                          | Goes to                                         |
| -------------------------------------- | ----------------------------------------------- |
| `<C-]>`                                | Definition of the word under the cursor         |
| `<C-F>g`                               | Definition, opened in a new vertical split (my map) |
| `grt`                                  | Type definition (e.g. the interface of a variable) |
| `gri`                                  | Implementations (of an interface / abstract method) |
| `:lua vim.lsp.buf.declaration()`       | Declaration (no default key)                    |

If there's exactly one target, Neovim jumps there. If there are several, it
opens the **quickfix list** at the bottom (see
[Moving through result lists](#moving-through-result-lists)).

### Going back (and forward again)

Every LSP jump goes on two stacks, so there are two ways back:

| Key / command   | Stack     | Action                                            |
| --------------- | --------- | ------------------------------------------------- |
| `<C-o>`         | jumplist  | **Back to where you were** (works for any big jump: LSP, search, `G`, `%`…) |
| `<C-i>` / `Tab` | jumplist  | Forward again                                     |
| `:pop`          | tag stack | Back one definition jump only                     |
| `:tags`         | tag stack | Show the chain of definition jumps                |
| `:jumps`        | jumplist  | Show the whole jump history                       |

`<C-t>` would normally do what `:pop` does, but in my setup it toggles NERDTree.

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

Same things in the fuzzy picker (filter as you type, with a preview):

| Key           | Picker                                     |
| ------------- | ------------------------------------------ |
| `<leader>fR`  | References                                 |
| `<leader>fs`  | Symbols in this file                       |
| `<leader>fS`  | Symbols in the whole project (live search) |
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
- vtsls runs on whichever Node nvm has active in the shell that starts Neovim.
- `~/.local/state/nvim/lsp.log`: server errors. `Command setContext not found`
  in there is harmless vtsls noise.

## Problems, linting and formatting

TypeScript errors (vtsls) and eslint errors (ALE) show up as one list of
problems, so the same keys cover both.

| Key           | Action                               |
| ------------- | ------------------------------------ |
| `]d` / `[d`   | Next / previous problem              |
| `<leader>aj` / `<leader>ak` | Next / previous problem + popup (my maps) |
| `<C-w>d`      | Show the problem under the cursor    |
| `<leader>fd` / `<leader>fD` | Picker: problems in this file / project |

### ALE (eslint + prettier)

- `:ALEFix` runs the fixers (prettier, eslint, trailing whitespace). Not on save.
- `:ALEInfo` shows which linters/fixers run for the current file.
- Uses the project's own `node_modules` eslint/prettier first.

## Vallow (Fallow in Neovim)

[vallow.nvim](https://github.com/xeind/vallow.nvim) surfaces
[Fallow](https://crates.io/crates/fallow-cli) findings inside Neovim. Needs the
`fallow` binary on `PATH` (`cargo install fallow-cli`).

| Key           | Action                         |
| ------------- | ------------------------------ |
| `<leader>V`   | Toggle the Vallow panel        |
| `<leader>vr`  | Refresh findings               |
| `<leader>vs`  | Search findings                |
| `<leader>va`  | Act on the current finding     |
| `]v` / `[v`   | Next / previous finding        |

Also: `:Vallow`, `:VallowRefresh`, `:VallowSearch`.

## Git (IntelliJ-style)

Three tools, each covering part of what IntelliJ does:
- **codediff.nvim**: the review windows (Changes, Compare, History, Merge),
  using VS Code's diff engine with word- and character-level highlights.
- **gitsigns.nvim**: change markers in the margin, actions on single changes,
  and blame.
- **fugitive**: `:Git …` commands.

Hunk keys mean the same thing in normal buffers and inside CodeDiff:
`]c` / `[c` move, `<leader>hs` stages, `<leader>hr` reverts.

### IntelliJ → here

| IntelliJ | Key / command |
| --- | --- |
| Commit / Changes window | `<leader>gd` (`:CodeDiff`); staged only: `:CodeDiff --staged` |
| Compare with branch / revision | `<leader>gD`, then type e.g. `master...` (Tab completes branches) |
| Show History (file) | `<leader>gh` (`:CodeDiff history %`) |
| Show History for selection | select lines, then `<leader>gh` |
| Repository log | `<leader>gH` (`:CodeDiff history`); fuzzy: `<leader>gc` |
| Resolve conflicts | `<leader>gm` (`:CodeDiff merge %`), see [Resolving merge conflicts](#resolving-merge-conflicts) |
| Gutter markers, Rollback, Show Diff popup | gitsigns, see below |
| Annotate | `<leader>gB` (`:Git blame`), or `<leader>hb` for one line |
| Git status / branches (fuzzy) | `<leader>gs` / `<leader>gb` (fzf-lua) |

### In any file (gitsigns)

Margin markers: `┃` added or changed (in different colours), `▁` / `▔` lines deleted
below / above, `~` changed and partly deleted, `┆` untracked file. The sign
column is 2 wide, so a git marker and an error marker can share a line.

| Key | Action |
| --- | --- |
| `]c` / `[c` | Next / previous change (in diff mode: Vim's own `]c`) |
| `<leader>hp` | Preview the change in a popup (like IntelliJ's gutter click) |
| `<leader>hi` | Preview the change inline |
| `<leader>hs` | Stage the change; on an already-staged change it unstages |
| `<leader>hr` | Revert (roll back) the change |
| `<leader>hs` / `<leader>hr` in visual mode | Stage / revert only the selected lines |
| `<leader>hS` / `<leader>hR` | Stage / revert the whole file |
| `<leader>hb` | Blame for this line (popup with the full commit) |
| `<leader>tb` | Toggle blame shown at the end of the current line |
| `<leader>hd` | Quick side-by-side diff of this file against the index |
| `ih` | Text object: the change under the cursor (`vih`, `dih`, `yih`) |

### Inside a CodeDiff window

It opens in a new tab; `q` closes it, `g?` lists every key.

**Diff panes**

| Key | Action |
| --- | --- |
| `]c` / `[c` | Next / previous change |
| `]f` / `[f` | Next / previous file |
| `<leader>hs` / `<leader>hu` / `<leader>hr` | Stage / unstage / discard the change under cursor |
| `-` | Stage / unstage the whole file |
| `gS` | Switch between the staged and unstaged diff of this file |
| `do` / `dp` | Take the change from / push it to the other pane |
| `t` | Toggle side-by-side / inline layout |
| `gc` | Fold unchanged code (compact mode) |
| `gm` | Line up a moved block across panes |
| `gf` | Open this file in a normal tab to edit it |
| `<leader>b` / `<leader>e` | Hide / focus the file list |

**File list (explorer)**

| Key | Action |
| --- | --- |
| `Enter` | Show the diff of that file |
| `-` | Stage / unstage the file |
| `S` / `U` | Stage all / unstage all |
| `X` | Discard the file's changes |
| `i` | Switch list / tree view |
| `R` | Refresh |
| `K` | Show the full path |

**History** (`<leader>gh`, `<leader>gH`): `Enter` expands a commit or opens a
file's diff against its parent; `i` switches list / tree; `R` refreshes.

### Resolving merge conflicts

Open the merge view in one of two ways:
- `<leader>gd` (`:CodeDiff`): conflicted files have their own **Conflicts**
  group in the file list; `Enter` on one opens it.
- `<leader>gm` (`:CodeDiff merge %`) on the conflicted file itself.

```
┌───────────────────────┬───────────────────────┐
│ INCOMING (theirs, :3) │ CURRENT (ours, :2)    │
├───────────────────────┴───────────────────────┤
│ RESULT: the real file, editable               │
└───────────────────────────────────────────────┘
```

Margin colours on each conflict: orange unresolved, green the side you took,
red the side you dropped, grey resolved.

Moving around:

| Key | Action |
| --- | --- |
| `]x` / `[x` | Next / previous **conflict** |
| `]c` / `[c` | Next / previous change (any hunk, conflicting or not) |
| `]f` / `[f` | Next / previous file in the file list |
| `<C-w>h/j/k/l` | Move between panes |
| `<leader>e` / `<leader>b` | Focus / hide the file list |
| `g?` | Every key for the pane you're in |

Resolving (cursor on a conflict, in any of the three panes):

| This conflict | Whole file | Action |
| --- | --- | --- |
| `<leader>ct` | `<leader>cT` | Take incoming (theirs) |
| `<leader>co` | `<leader>cO` | Take current (ours) |
| `<leader>cb` | `<leader>cB` | Take both |
| `<leader>cx` | `<leader>cX` | Drop both, keep the base |
| `2do` / `3do` | | (result pane only) Take the hunk from incoming / current, vimdiff-style |

- `.` repeats the last single-conflict choice, so `]x` `.` `]x` `.` walks
  through the file.
- The result pane is a normal buffer: edit it by hand when neither side is
  right (e.g. merging two dependency lists).

Finishing a file:
1. `:w` in the result pane.
2. `-` (in the diff or the file list) stages it, which tells git it's
   resolved. Same as `git add <file>`.
3. `q` closes the tab; then `git merge --continue` / `git rebase --continue`
   / `git commit`.

Gotchas:
- After resolving `package.json`, run `npm install` so the lockfile catches up.
- `git mergetool` leaves `*_BACKUP_*`, `*_BASE_*`, `*_LOCAL_*`, `*_REMOTE_*`
  files behind (and `*.orig`). Delete them once done; to hide them from the
  file list, set `diff = { hide_merge_artifacts = true }` in codediff's `opts`.

### Optional: use CodeDiff for `git difftool` / `git mergetool`

Not configured. To make the git commands open CodeDiff:

```sh
git config --global diff.tool codediff
git config --global difftool.codediff.cmd 'nvim "$LOCAL" "$REMOTE" +"CodeDiff --exit-on-close file $LOCAL $REMOTE"'
git config --global merge.tool codediff
git config --global mergetool.codediff.cmd 'nvim "$MERGED" -c "CodeDiff --exit-on-close merge \"$MERGED\""'
```

Notes:
- On first use CodeDiff downloads two helpers from its GitHub releases: the
  diff library and a file watcher that refreshes the view live.
- Pull-request review (`:CodeDiff pr 123`) is for GitHub repos, so it doesn't
  apply to Phabricator.

## Setup and maintenance

### Commands

| Command               | What                                     |
| --------------------- | ---------------------------------------- |
| `:Lazy`               | Plugin manager UI                        |
| `:Lazy sync`          | Install + update + clean plugins         |
| `:Mason`              | Language servers / tools UI              |
| `:TSUpdate`           | Update treesitter parsers                |
| `:checkhealth`        | Diagnose problems                        |

nvim-treesitter is pinned to `master`; `main` is an incompatible rewrite.

### Where things live

- `~/.config/nvim/init.lua`: options, keymaps, NERDTree autocmds, colorscheme, Neovide settings; calls `require("config.lazy")`
- `~/.config/nvim/lua/config/lazy.lua`: lazy.nvim bootstrap
- `~/.config/nvim/lua/plugins/init.lua`: most plugins (NERDTree, ALE, treesitter, vim-tmux-navigator, themes…)
- `~/.config/nvim/lua/plugins/picker.lua`: fzf-lua (Telescope profile + keys)
- `~/.config/nvim/lua/plugins/git.lua`: codediff + gitsigns (keys for git)
- `~/.config/nvim/lua/plugins/vallow.lua`: vallow.nvim (Fallow findings)
- `~/.config/nvim/lua/plugins/completion.lua`: blink.cmp
- `~/.config/nvim/lua/plugins/lsp.lua`: mason + vtsls
- Active colorscheme: `everforest` (set in `init.lua`; others stay installed)
- `~/.local/share/nvim/lazy/`: installed plugins
- `~/.local/share/nvim/mason/`: installed language servers
- Backups from the migrations: `~/.config/nvim/init.vim.bak`,
  `~/.config/nvim/init.vim.bak-pre-initlua`.
