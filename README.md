# needle.nvim

`Needle` is a Neovim plugin designed for easy management, navigation, and viewing of local marks.

## What does it do?

- Automatically assigns an available character from `q` to `n` for creating local marks.
- Renames marks dynamically when they are added or removed, making their positions relative to the keybindings.
- Displays and updates all marks in the sign column.
  
## Demo

![demo](https://i.imgur.com/UMlThqn.gif)

## Installation

### Lazy

```lua
return {
    "Jofr3/needle",
    lazy = false,
    opts = {}
}
```

## Usage

```
 M          Add a mark
 m[q-n]     Jump to [q-n] mark
 dm         Remove the mark under the cursor
 m]         Jump to next mark
 m[         Jump to previouse mark
 dM         Clear all marks
```

### Or

- `:lua require('needle.mark').add_mark()` to add a mark at the cursor.
- `:lua require('needle.mark').jump_to_mark('[q-n]')` to jump to [a-z] mark.
- `:lua require('needle.mark').remove_mark()` to delete the mark at the cursor.
- `:lua require('needle.mark').jump_to_next()` to jump to the next mark.
- `:lua require('needle.mark').jump_to_prev()` to jump to the previouse mark.
- `:lua require('needle.mark').clear_marks()` to delete all local marks.

## Configuration

No configuration avaiable yet.

## To do

- Configuration.
- Use marks with verbs (change, select, delete, ...).

## Known issues

- It interferes with Lsp diagnostics signs. Temporary fix: disable Lsp diagnostic signs altogether.

```lua
vim.diagnostic.config({
    signs = false
})
```

## Similar plugins

- [marks.nvim](https://github.com/chentoast/marks.nvim)
- [Harpoon](https://github.com/ThePrimeagen/harpoon)
