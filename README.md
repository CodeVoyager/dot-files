# dot-files

My macOS terminal setup: zsh, Neovim, tmux and Alacritty.

Files are laid out as they sit under `$HOME`, so `.vimrc` here is `~/.vimrc` and
`.config/tmux/tmux.conf` is `~/.config/tmux/tmux.conf`.

## What's inside

| Path | What |
| --- | --- |
| `.zshrc` | oh-my-zsh, nvm, Android / Java / pnpm paths; sources the two files below |
| `.config/.aliases` | Shell aliases (git, directories, Xcode switching, …) |
| `.config/.profile` | Sources `.aliases` (for shells that read a profile) |
| `.vimrc` | Options and keymaps shared by Vim and Neovim. Vim uses vim-plug; Neovim loads lazy.nvim |
| `.config/nvim/` | Neovim: `init.vim` sources `~/.vimrc`; plugins in `lua/plugins/` (lazy.nvim) |
| `.config/nvim/lazy-lock.json` | Exact plugin versions; `:Lazy restore` installs these |
| `.config/tmux/tmux.conf` | tmux settings + TPM plugins (sensible, resurrect, continuum, vim-tmux-navigator) |
| `.config/alacritty/alacritty.toml` | Alacritty: FiraMono Nerd Font, Shift+Enter binding |
| `docs/vim-tips.md` | Cheat sheet for this Neovim setup (completion, LSP, fzf-lua, …) |
| `docs/tmux-tips.md` | Cheat sheet for this tmux setup |

### Neovim at a glance

- **Plugins:** lazy.nvim
- **Completion:** blink.cmp
- **TypeScript:** vtsls via mason and Neovim's built-in LSP
- **Lint / format:** ALE with eslint and prettier
- **Fuzzy finder:** fzf-lua with the Telescope profile
- **Syntax:** nvim-treesitter (pinned to `master`)
- **Also:** NERDTree, vim-tmux-navigator, tokyonight

## Setting up a new Mac

1. **Tools**

   ```sh
   brew install neovim tmux fzf ripgrep git node
   brew install --cask alacritty font-fira-mono-nerd-font
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

   Also install [nvm](https://github.com/nvm-sh/nvm). Neovim's TypeScript server
   runs on the Node it provides.

2. **Copy the files into place** (back up existing ones first):

   ```sh
   git clone git@github.com:CodeVoyager/dot-files.git ~/projekty/dot-files
   cd ~/projekty/dot-files
   cp .zshrc .vimrc ~/
   mkdir -p ~/.config
   cp -R .config/. ~/.config/
   ```

3. **tmux plugins**

   ```sh
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```

   Then start tmux and press `C-b I` to install the plugins.

4. **Neovim:** run `nvim` once. lazy.nvim installs itself and the plugins, and
   mason installs the TypeScript server (vtsls). Run `:checkhealth` if anything
   looks off.

5. **Plain Vim (optional):** install
   [vim-plug](https://github.com/junegunn/vim-plug), then run `:PlugInstall`.

## Updating this repo

These are copies, not symlinks. After changing a config locally, copy it back
and commit:

```sh
cd ~/projekty/dot-files
cp ~/.vimrc .vimrc        # etc. for each changed file
git diff                  # review
```
