# nvim-mult_hili

A neovim plugin to highlight multiple patterns. This plugin doesn't work with vim as it uses lua api. This plugin has a css named color list, so you doesn't need to think of color and their names.

## Usage

### Prerequirements

    - Neovim: this plugin uses lua.
    - 'termguicolors': this plugin uses 24-bit rgb colors in TUI, so 'termguicolors' is a must.

### Commands

This plugin adds the following Ex commands:

    - MultHiliAdd {pattern}: highlight {pattern} with the next available color.
    - MultHiliList: list current patterns, with their ID and color name.
    - MultHiliDelete {ID}: delete a highlight pattern by ID.
    - MultHiliDeleteStr {pattern}: delete all highlights whose pattern is equal to {pattern}.
    - MultHiliNext {ID}: goto next pos where highlight {ID} matches.
    - MultHiliPrev {ID}: goto previous pos where highlight {ID} matches.
