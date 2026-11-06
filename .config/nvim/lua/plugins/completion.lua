-- Completion: blink.cmp (LSP, file paths, snippets, buffer words)
return {
  {
    "saghen/blink.cmp",
    -- a release tag, so the prebuilt Rust fuzzy matcher is downloaded
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- "default": <C-y> accept, <C-n>/<C-p> or <Up>/<Down> select, <C-space> open,
      -- <C-e> close, <C-k> signature help. Alternatives: "super-tab", "enter".
      keymap = { preset = "default" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
