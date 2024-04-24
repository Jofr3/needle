# Needle

`Needle` is a Neovim plugin for easily managing, navigating and viewing local marks.

## What does it do?

- Lets you create local marks, and assigns an available character automatically, from `q` to `m`.
- It renames all of the marks when adding or removing them, so the marks stay relative to the keybinds.
- It displays and updates all the marks on the sign column.
  
## Demo

![demo](demo.gif)

## Why?

When I first discovered local marks in `Neovim` I saw a lot of potential in them, but the lack of speed, flexibility and ease of use kept me from using them. After some searching, I didn't fine a solution that satisfied me, so I took it upon myself. This plugin is heavily inspired by `Harpoon` (hence this plugin name), since it also deals with marks, but just global ones. I wanted a similar experience when it comes to ease of use and flexibility.

## Installation

### Lazy

```lua
return {
    "Jofr3/needle",
    config = function()
        require("needle").setup()
    end
}
```

## Usage

- `:lua require('needle.marks').add_mark()` to add a mark at the cursor.
- `:lua require('needle.marks').jump_to_mark('[a-z]')` to jump to [a-z] mark.
- `:lua require('needle.marks').delete_mark()` to delete the mark at the cursor.
- `:lua require('needle.marks').clear_marks()` to delete all local marks.

## Example keybinds

### Lazy 

```lua
keys = {
    { "<C-l>", "<cmd>:lua require('needle.marks').add_mark()<cr>", remap = true, desc = "Add mark" },
    { "<C-x>", "<cmd>:lua require('needle.marks').delete_mark()<cr>", remap = true, desc = "Delete mark" },
    { "<Leader>x", "<cmd>:lua require('needle.marks').clear_marks()<cr>", remap = true, desc = "Clear marks" },

    { "<Leader>q", "<cmd>:lua require('needle.marks').jump_to_mark('q')<cr>", remap = true, desc = "Jump to mark q" },
    { "<Leader>w", "<cmd>:lua require('needle.marks').jump_to_mark('w')<cr>", remap = true, desc = "Jump to mark w" },
    { "<Leader>e", "<cmd>:lua require('needle.marks').jump_to_mark('e')<cr>", remap = true, desc = "Jump to mark e" },
    { "<Leader>r", "<cmd>:lua require('needle.marks').jump_to_mark('r')<cr>", remap = true, desc = "Jump to mark r" },
    { "<Leader>t", "<cmd>:lua require('needle.marks').jump_to_mark('t')<cr>", remap = true, desc = "Jump to mark t" },
    -- ...
}
```

### Lua

```lua
vim.keymap.set("n", "<C-l>", ":lua require('needle.marks').add_mark()<CR>")
vim.keymap.set("n", "<C-x>", ":lua require('needle.marks').delete_mark()<CR>")
vim.keymap.set("n", "<Leader>x", ":lua require('needle.marks').clear_marks()<CR>")

vim.keymap.set("n", "<Leader>q", ":lua require('needle.marks').jump_to_mark('q')<CR>")
vim.keymap.set("n", "<Leader>w", ":lua require('needle.marks').jump_to_mark('w')<CR>")
vim.keymap.set("n", "<Leader>e", ":lua require('needle.marks').jump_to_mark('e')<CR>")
vim.keymap.set("n", "<Leader>r", ":lua require('needle.marks').jump_to_mark('r')<CR>")
vim.keymap.set("n", "<Leader>t", ":lua require('needle.marks').jump_to_mark('t')<CR>")
-- ...
```

## Configuration

No configuration avaiable yet.

## Known issues

- It interferes with Lsp diagnostics signs. Temporary fix: disable Lsp diagnostic signs altogether.

```lua
vim.diagnostic.config({
    signs = false
})
```
