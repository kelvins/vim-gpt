" Author: Kelvin Salton <http://github.com/kelvins>
" Description: Utility functions

function! gpt#util#echo(content)
    redraw
    echom a:content
endfunction

function! gpt#util#prompt()
    call inputsave()
    let l:prompt = input('Prompt: ')
    call inputrestore()
    return substitute(l:prompt, "\"", "'", "g")
endfunction

function! gpt#util#write(content)
    call append(line('$'), a:content)
endfunction
