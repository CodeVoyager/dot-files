-- Language servers through Neovim's built-in LSP client.
-- mason.nvim installs the servers, nvim-lspconfig provides their default configs,
-- and mason-lspconfig calls vim.lsp.enable() for every installed server.
return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "vtsls" }, -- TypeScript / JavaScript / TSX
    },
    config = function(_, opts)
      -- show LSP errors inline, like ALE does for eslint
      vim.diagnostic.config({ virtual_text = true })
      require("mason-lspconfig").setup(opts)
    end,
  },
}
