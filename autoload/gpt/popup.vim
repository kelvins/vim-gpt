" Author: Kelvin Salton <http://github.com/kelvins>
" Description: Popup functions

function! gpt#popup#create(content)

    let l:content = a:content
    function! s:filter(winid, key) closure
        if a:key == 'q'
            call popup_close(a:winid)
            return 1
        elseif a:key == 'w'
            call popup_close(a:winid)
            call gpt#util#write(l:content)
            return 1
        endif
        return 0
    endfunction

    let s:popup_settings = {
        \ "filter": "s:filter",
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

    call popup_clear()
    let l:winid = popup_create(a:content, s:popup_settings)
    call setwinvar(l:winid, '&wincolor', g:gpt_preview_wincolor)
endfunction
