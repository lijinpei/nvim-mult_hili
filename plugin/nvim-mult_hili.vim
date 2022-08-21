if exists("g:nvim_mult_hili") || !has("nvim")
    finish
endif
let g:nvim_mult_hili = 1

lua require('mult_hili')

function! Add_highlight(pattern)
    call luaeval("require('mult_hili').add_highlight(\""+a:pattern+"\")",[])
endfunction

command! -nargs=1 MultHiliAdd call luaeval("require('mult_hili').add_highlight('<args>')", v:null)
command! -nargs=1 MultHiliDelete call luaeval("require('mult_hili').delete_highlight(<args>)", v:null)
command! -nargs=1 MultHiliDeleteStr call luaeval("require('mult_hili').delete_highlight('<args>')", v:null)
command! -nargs=1 MultHiliNext call luaeval("require('mult_hili').next_pos(<args>)", v:null)
command! -nargs=1 MultHiliPrev call luaeval("require('mult_hili').prev_pos(<args>)", v:null)
command! -nargs=0 MultHiliList call luaeval("require('mult_hili').list_highlights()", v:null)
