return {
  {
    "xeind/vallow.nvim",
    cmd = { "Vallow", "VallowRefresh", "VallowSearch" },
    keys = {
      { "<leader>V",  "<cmd>Vallow<cr>",        desc = "Vallow: toggle" },
      { "<leader>vr", "<cmd>VallowRefresh<cr>", desc = "Vallow: refresh" },
      { "<leader>vs", "<cmd>VallowSearch<cr>",  desc = "Vallow: search findings" },
      { "<leader>va", "<cmd>Vallow action<cr>", desc = "Vallow: act on finding" },
      { "]v",         "<cmd>Vallow next<cr>",   desc = "Vallow: next finding" },
      { "[v",         "<cmd>Vallow prev<cr>",   desc = "Vallow: previous finding" },
    },
    opts = {},
  }
}
