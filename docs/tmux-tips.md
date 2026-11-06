# tmux tips (my setup)

Written 2026-11-06. tmux 3.8. Config: `~/.config/tmux/tmux.conf`.
Plugins (TPM): tmux-sensible, tmux-resurrect, tmux-continuum,
vim-tmux-navigator. Mouse is on (3.8 default). Prefix is `C-b` (written `P`
below: press `C-b`, let go, then the key). Every key here was checked
against `tmux list-keys` on 2026-11-06.

**`M-` keys (Option) don't work in my Alacritty yet.** Alacritty's
`option_as_alt` defaults to `"None"`, so Option never reaches tmux as Meta.
To enable it, add to `~/.config/alacritty/alacritty.toml`:
`[window]` / `option_as_alt = "OnlyLeft"` (or `"Both"`). Use `"OnlyLeft"` if
you type special characters (e.g. Polish letters) with right Option. Each
`M-` key below lists a fallback.

## Moving around

tmux has four levels, one inside the other:

```
server  (one per machine; survives closing the terminal)
└── session   ("0", "work", …: a whole workspace, e.g. one per project)
    └── window    (a tab in the status bar: "0:nvim 1:zsh 2:node")
        └── pane      (a split inside a window)
```

The status bar shows the session name in `[brackets]` on the left, then the
windows as `number:name`. `*` marks the current window, `-` the previous one,
and `Z` a zoomed one.

**Between panes** (inside one window)
- `C-h` / `C-j` / `C-k` / `C-l` (no prefix) move left / down / up / right
  (vim-tmux-navigator). Inside Neovim they move between splits first and carry on
  into tmux panes at the edge. `C-\` goes to the previous pane.
- `P ←↑↓→` moves to the pane in that direction. After the prefix you can
  press arrows repeatedly for a moment without pressing `P` again.
- `P o` cycles through panes. `P q` flashes pane numbers; press one to jump.
- `P ;` goes back to the pane you were in last.
- `P z` zooms the current pane to fill the window (the window name gets a
  `Z`). Moving to another pane, or `P z` again, unzooms.
- Mouse: click a pane.

**Between windows** (inside one session)
- `P 0`…`P 9` jumps straight to a window number.
- `P n` / `P p` (or `P C-n` / `P C-p`) go to the next / previous window.
- `P l` toggles to the last window you were in, which is the fastest way to flip
  between two.
- `P w` opens a tree of every window with a live preview. Move with arrows,
  `Enter` to go there.
- `P f` finds a window by text shown in it.
- Mouse: click a window name in the status bar.

**Between sessions**
- `P s` opens the session tree (`→` expands a session's windows).
- `P (` / `P )` go to the previous / next session, and `P L` to the last one.
- From a shell: `tmux switch -t work` (inside tmux) or `tmux a -t work`
  (outside).

**Inside a pane's history** (copy mode)
- `P [`, `P PgUp` or the mouse wheel enters it. You're in copy mode when
  there's a `[n/m]` position counter at the top right.
- Arrows / `PgUp` / `PgDn` move; `g` goes to a line number; `M-<` / `M->`
  jump to the top / bottom (Option, see top).
- `C-s` / `C-r` search down / up, then `n` / `N` for the next / previous match.
- `q` or `Esc` leaves copy mode and returns to the live output.

**Out and back in**
- `P d` detaches: tmux and everything in it keeps running. `tmux a` comes
  back to it.
- After a reboot, continuum restores the last saved layout automatically
  when tmux starts. `P C-r` restores by hand.

## Sessions

| Command / key              | Action                                   |
| -------------------------- | ---------------------------------------- |
| `tmux new -s work`         | New session named "work"                 |
| `tmux ls`                  | List sessions                            |
| `tmux a` / `tmux a -t work`| Attach to last / named session           |
| `tmux kill-session -t work`| Kill a session                           |
| `P d`                      | Detach (session keeps running)           |
| `P s`                      | Pick a session (tree view)               |
| `P $`                      | Rename session                           |
| `P (` / `P )`              | Previous / next session                  |
| `P L`                      | Last session                             |

Tip: name sessions per project (`tmux new -s ep-native`); the current one
is just `0`.

## Windows (tabs)

| Key          | Action                                 |
| ------------ | -------------------------------------- |
| `P c`        | New window                             |
| `P ,`        | Rename window                          |
| `P n` / `P p`| Next / previous window                 |
| `P l`        | Last window                            |
| `P 0`…`P 9`  | Go to window by number                 |
| `P w`        | Pick a window (tree view with preview) |
| `P f`        | Find window by text                    |
| `P &`        | Kill window (asks first)               |

## Panes (splits)

| Key                 | Action                                        |
| ------------------- | --------------------------------------------- |
| `P %`               | Split left / right                            |
| `P "`               | Split top / bottom                            |
| `P ←↑↓→`            | Move between panes                            |
| `P o`               | Next pane                                     |
| `P q` then number   | Show pane numbers / jump to one               |
| `P z`               | Zoom pane to full window (again to unzoom)    |
| `P C-←↑↓→`          | Resize by 1 (hold arrow to repeat)            |
| `P M-←↑↓→`          | Resize by 5 (Option; fallback: `P C-←↑↓→` repeatedly, or drag the border) |
| `P Space`           | Cycle layouts                                 |
| `P {` / `P }`       | Swap pane with previous / next                |
| `P !`               | Break pane out into its own window            |
| `P x`               | Kill pane (asks first)                        |

With the mouse: click a pane to focus it, drag a border to resize.

## Scrolling & copying (copy mode, emacs keys)

| Key                 | Action                                  |
| ------------------- | --------------------------------------- |
| `P [`               | Enter copy mode (or scroll the wheel)   |
| `P PgUp`            | Enter copy mode one page up             |
| arrows / `PgUp/PgDn`| Move / scroll                           |
| `C-s` / `C-r`       | Search down / up                        |
| `n` / `N`           | Next / previous search match            |
| `M-<` / `M->`       | Top / bottom of history (Option)        |
| `g`                 | Go to line                              |
| `C-Space`           | Start selection                         |
| `C-w` or `M-w`      | Copy selection and exit (`C-w` needs no Option) |
| `q` / `Esc`         | Exit copy mode                          |
| `P ]`               | Paste the last copied text              |
| `P =`               | Pick from copy history                  |

Mouse: drag to select, which copies on release. Double-click copies a word,
triple-click a line.

## Handy extras

| Key / command       | Action                                   |
| ------------------- | ---------------------------------------- |
| `P ?`               | List all key bindings                    |
| `P :`               | Command prompt (e.g. `:kill-server`)     |
| `P i`               | Info about the current pane              |
| `P t`               | Big clock                                |
| `P R`               | Reload config (from tmux-sensible)       |

## Plugins (TPM)

| Key      | Action                                                      |
| -------- | ----------------------------------------------------------- |
| `P C-s`  | Save all sessions, windows, panes and their directories (resurrect) |
| `P C-r`  | Restore the last save (resurrect)                           |
| `P I`    | Install plugins newly added to tmux.conf                    |
| `P U`    | Update plugins                                              |
| `P M-u`  | Remove plugins no longer listed in tmux.conf (Option; fallback: run `~/.config/tmux/plugins/tpm/bin/clean_plugins`) |

- continuum saves automatically every 15 minutes and restores the last save
  when the tmux server starts (`@continuum-restore 'on'`).
- Saves live in `~/.local/share/tmux/resurrect/`.
- Plugins live in `~/.config/tmux/plugins/`.
- **vim-tmux-navigator** owns `C-h/j/k/l` and `C-\` in every pane. Because of that:
  - **Clear screen** is now `P C-l` (bound in tmux.conf).
  - In shells, the readline keys `C-h` (backspace), `C-j` (newline) and
    `C-k` (kill to end of line) move panes instead. Backspace and Enter do
    the same as `C-h` and `C-j`. Only `C-l` has a prefixed version; if you
    miss kill-line, add `bind C-k send-keys 'C-k'` to tmux.conf for `P C-k`.
  - In Claude Code, `C-j` no longer inserts a newline; use `\` then Enter.
  - Neovim side: lazy.nvim spec in `~/.config/nvim/lua/plugins/init.lua`.
- tmux-sensible also set: messages show for 4 s, the status bar refreshes every 5 s,
  `aggressive-resize` is on, and `P C-n` / `P C-p` change windows. It left my
  10 ms `escape-time` alone.

## Applied on 2026-11-06

In `~/.config/tmux/tmux.conf`:

```tmux
set -g focus-events on        # Neovim autoread / focus events (checkhealth asked for it)
set -g history-limit 50000    # was 2000 lines
# + TPM with tmux-sensible, tmux-resurrect, tmux-continuum (see Plugins above)
# + vim-tmux-navigator (C-h/j/k/l across tmux and Neovim), clear screen on P C-l
```

Already fine, no change needed: `escape-time` is 10 ms, true colour works
(my terminal reports `RGB`), and `default-terminal` is `tmux-256color`.

## Not applied yet (common in tmux configs)

Add any of these to `~/.config/tmux/tmux.conf` **above** the TPM `run` line,
then `P R` to reload.

### Quality-of-life defaults most configs change

```tmux
# Number windows and panes from 1 so they match the keyboard row
set -g base-index 1
setw -g pane-base-index 1
# Close gaps in window numbers when one is closed
set -g renumber-windows on

# New splits and windows open in the current pane's directory
bind '"' split-window -v -c "#{pane_current_path}"
bind %   split-window -h -c "#{pane_current_path}"
bind c   new-window -c "#{pane_current_path}"

# Killing a session switches to another one instead of detaching
set -g detach-on-destroy off
```

### Vim-style keys

```tmux
# vi keys in copy mode: v to select, y to copy, / ? to search
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-pipe-and-cancel

# P h/j/k/l to move between panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
```

Note: `bind l` replaces the default "last window" (`P l`). Since
vim-tmux-navigator already gives `C-h/j/k/l` without the prefix, these are
only worth it if you want prefixed versions too.

### Clipboard

Copying already sends text to the terminal via OSC 52 (`set-clipboard
external`). Whether it reaches the macOS clipboard depends on the terminal
allowing it. If copied text doesn't paste outside tmux:

```tmux
set -s copy-command 'pbcopy'
```

### Optional, a matter of taste

- **`C-a` as prefix** (`set -g prefix C-a`, `unbind C-b`, `bind C-a send-prefix`).
  It's easier to reach, but it takes over the shell's "start of line" key.
- **Status bar theme**: a tokyonight tmux theme would match Neovim. Several
  are available as TPM plugins.
- **`set -g status-position top`**: some people prefer the bar at the top.
