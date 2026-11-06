-- Git, IntelliJ-style:
--   codediff.nvim  = Changes / Compare / History / Merge windows (VS Code diff engine)
--   gitsigns.nvim  = change markers in the gutter, hunk actions, inline blame
--   vim-fugitive   = :Git commands (in plugins/init.lua)
-- Hunk keys match codediff's diff view: ]c/[c move, <leader>hs stage, <leader>hr reset.
return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<CR>", desc = "Git: changes (working tree)" },
      { "<leader>gD", ":CodeDiff ", desc = "Git: compare with… (type revision, e.g. master...)" },
      { "<leader>gh", "<cmd>CodeDiff history %<CR>", desc = "Git: history of this file" },
      { "<leader>gh", ":CodeDiff history<CR>", mode = "x", desc = "Git: history of selected lines" },
      { "<leader>gH", "<cmd>CodeDiff history<CR>", desc = "Git: repository history" },
      { "<leader>gm", "<cmd>CodeDiff merge %<CR>", desc = "Git: resolve conflicts in this file" },
    },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      -- room for a git marker and a diagnostic sign side by side
      vim.opt.signcolumn = "auto:2"
    end,
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- jump between changes (falls back to Vim's ]c/[c in diff mode)
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Next git change")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Previous git change")

        -- hunk actions
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview change (popup)")
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview change (inline)")
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage / unstage change")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Revert change")
        map("x", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected lines")
        map("x", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Revert selected lines")
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage whole file")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Revert whole file")

        -- blame
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame this line (popup)")
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gB", "<cmd>Git blame<CR>", "Blame whole file (fugitive)")

        -- quick diff of this file against the index
        map("n", "<leader>hd", gitsigns.diffthis, "Diff this file")

        -- `ih` = the change under the cursor (vih, dih, yih)
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git change")
      end,
    },
  },
}
