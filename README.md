# dot-files

My macOS terminal setup: zsh, Neovim, tmux and Alacritty.

Files are laid out as they sit under `$HOME`, so `.zshrc` here is `~/.zshrc` and
`.config/tmux/tmux.conf` is `~/.config/tmux/tmux.conf`.

## What's inside

| Path | What |
| --- | --- |
| `.zshrc` | oh-my-zsh, nvm, Android / Java / pnpm paths; sources the two files below |
| `.config/.aliases` | Shell aliases (git, directories, Xcode switching, …) |
| `.config/.profile` | Sources `.aliases` (for shells that read a profile) |
| `.config/nvim/` | Neovim: `init.lua` has options, keymaps and the colorscheme; plugins in `lua/plugins/` (lazy.nvim) |
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
   brew install tmux fzf ripgrep git node
   brew install --cask font-fira-mono-nerd-font
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

   Neovim comes from the official release tarball
   ([install docs](https://neovim.io/doc/install/)), not Homebrew. On Apple
   Silicon:

   ```sh
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
   rm -rf ~/.local/nvim
   mkdir -p ~/.local
   tar -C ~/.local -xzf nvim-macos-arm64.tar.gz
   mv ~/.local/nvim-macos-arm64 ~/.local/nvim
   mkdir -p ~/.local/bin
   ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
   rm nvim-macos-arm64.tar.gz
   ```

   `~/.local/bin` is already on `PATH` via `.zshrc`. On Intel Macs use
   `nvim-macos-x86_64.tar.gz` instead.

   Alacritty's Homebrew cask is disabled (it fails the macOS Gatekeeper
   check), so install the `.dmg` from the
   [releases page](https://github.com/alacritty/alacritty/releases) instead:

   ```sh
   curl -LO https://github.com/alacritty/alacritty/releases/download/v0.17.0/Alacritty-v0.17.0.dmg
   hdiutil attach Alacritty-v0.17.0.dmg -nobrowse -quiet
   cp -R /Volumes/Alacritty/Alacritty.app /Applications/
   hdiutil detach /Volumes/Alacritty -quiet
   rm Alacritty-v0.17.0.dmg
   xattr -dr com.apple.quarantine /Applications/Alacritty.app
   ```

   Also install [nvm](https://github.com/nvm-sh/nvm). Neovim's TypeScript server
   runs on the Node it provides.

2. **Copy the files into place** (back up existing ones first):

   ```sh
   git clone git@github.com:CodeVoyager/dot-files.git ~/projekty/dot-files
   cd ~/projekty/dot-files
   cp .zshrc ~/
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

## Updating this repo

These are copies, not symlinks. After changing a config locally, copy it back
and commit:

```sh
cd ~/projekty/dot-files
cp ~/.config/nvim/init.lua .config/nvim/init.lua   # etc. for each changed file
git diff                  # review
```
