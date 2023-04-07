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
    \ "scrollbar": 1,
    \ }

function! gpt#popup#filter(winid, key)
    if a:key == 'q'
        call popup_close(a:winid)
        return 1
    elseif a:key == 'w'
        call popup_close(a:winid)
        call gpt#util#write(s:response)
        return 1
    endif
    return 0
endfunction

function! gpt#popup#create(content)
    call popup_clear()
    let l:winid = popup_create(a:content, s:popup_settings)
    call setwinvar(l:winid, '&wincolor', g:gpt_preview_wincolor)
endfunction
