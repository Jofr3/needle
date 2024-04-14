# Needle

`Needle` is a Neovim plugin for easily managing and vewing local marks.


## What does it do?

- Lets you create marks, and assigns an avaiable letter automaticly, from `q` to `m`.
- It renames all of the marks when adding or removing them, so the keybinds stay relative to the order of the marks.
- It displays the marks and its positions in the signcolumn.


## Installation

### Lazy

```lua
return {
    "Jofr3/needle",
    enabled = true,
    config = function()
        require("needle").setup()
    end
}
```


## Usage

- `:NeedleAddMark` to add a mark at the cursor.
- `:NeedleJumpToMark [a-z]` to jump to [a-z] mark.
- `:NeedleDeleteMark` to delete the mark at the cursor.
- `:NeedleClearMarks` to delete all local marks.


## Example keybinds

### Lazy 

```lua
keys = {
    { "<C-m>", "<cmd>:NeedleAddMark<CR>", remap = true, desc = "Add mark at cursor", { silent = true } },
    { "<C-x>", "<cmd>:NeedleDeleteMark<CR>", remap = true, desc = "Delete mark at cursor", { silent = true } },
    { "<Leader>x", "<cmd>:NeedleClearMarks<CR>", remap = true, desc = "Clear all local marks", { silent = true } },

    { "<Leader>q", "<cmd>:NeedleJumpToMark q<CR>", remap = true, desc = "Jump to mark", { silent = true } },
    { "<Leader>w", "<cmd>:NeedleJumpToMark w<CR>", remap = true, desc = "Jump to mark", { silent = true } },
    { "<Leader>e", "<cmd>:NeedleJumpToMark e<CR>", remap = true, desc = "Jump to mark", { silent = true } },
    { "<Leader>r", "<cmd>:NeedleJumpToMark r<CR>", remap = true, desc = "Jump to mark", { silent = true } },
    { "<Leader>t", "<cmd>:NeedleJumpToMark t<CR>", remap = true, desc = "Jump to mark", { silent = true } },
    { "<Leader>y", "<cmd>:NeedleJumpToMark y<CR>", remap = true, desc = "Jump to mark", { silent = true } }
}
```


### Lua

```lua
vim.keymap.set("n", "<C-m>", ":NeedleAddMark<CR>", { silent = true })
vim.keymap.set("n", "<C-x>", ":NeedleDeleteMark<CR>", { silent = true })
vim.keymap.set("n", "<Leader>x", ":NeedleClearMarks<CR>", { silent = true })

vim.keymap.set("n", "<Leader>q", ":NeedleJumpToMark q<CR>", { silent = true })
vim.keymap.set("n", "<Leader>w", ":NeedleJumpToMark w<CR>", { silent = true })
vim.keymap.set("n", "<Leader>e", ":NeedleJumpToMark e<CR>", { silent = true })
vim.keymap.set("n", "<Leader>r", ":NeedleJumpToMark r<CR>", { silent = true })
vim.keymap.set("n", "<Leader>t", ":NeedleJumpToMark t<CR>", { silent = true })
vim.keymap.set("n", "<Leader>y", ":NeedleJumpToMark y<CR>", { silent = true })
```


## Configuration

No configuration avaiable yet.


## Known issues

- It interfiers with Lsp diagnostics signs.
  Temporary fix: disable Lsp diagnostic signs altogether.
  ```lua
  vim.diagnostic.config({
      signs = false
  })
  ```


  ## Thanks to

  - ChatGPT
