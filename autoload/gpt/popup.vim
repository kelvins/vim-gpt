" Author: Kelvin Salton <http://github.com/kelvins>
" Description: Popup functions

let s:popup_settings = {
    \ "filter": "gpt#popup#filter",
    \ "title": "Preview (q-quit/w-write)",
    \ "border": [],
    \ "borderchars": ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
    \ "pos": "center",
    \ "minwidth": 80,
    \ "maxwidth": 80,
    \ "minheight": 20,
    \ "maxheight": 20,
    \ }

function! gpt#popup#filter(winid, key)
    if a:key == 'q'
        call popup_close(a:winid)
        return 1
    endif
    if a:key == 'w'
        call popup_close(a:winid)
        call append(line('$'), s:response)
        return 1
    endif
    return 0
endfunction

function! gpt#popup#create(content)
    call popup_clear()
    let winid = popup_create(a:content, s:popup_settings)
    call win_execute(winid, 'syntax enable')
    hi Pmenu ctermbg=gray
endfunction
