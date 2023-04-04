" Author: Kelvin Salton <http://github.com/kelvins>
" Plugin: https://github.com/kelvins/vim-gpt

let s:envars = environ()

" Global OpenAI variables
let g:openai_model = "gpt-3.5-turbo"
let g:openai_temperature = 0.7
let g:openai_api_key = s:envars["OPENAI_API_KEY"]

let s:openai_url = "https://api.openai.com/v1/chat/completions"

" GPT command must be called with at least 1 argument
command! -nargs=+ GPT call GPT(<f-args>)

" Function responsible for building OpenAI API request
function! BuildOpenAIRequest(prompt)
  let l:payload = [
    \ "{\\\"model\\\": \\\"" . g:openai_model . "\\\",",
    \ "\\\"temperature\\\": " . g:openai_temperature . ",",
    \ "\\\"messages\\\": [{\\\"role\\\": \\\"user\\\", \\\"content\\\": \\\"" . a:prompt . "\\\"}]}",
    \ ]
  let l:command = [
    \ 'curl -s ' . s:openai_url,
    \ '-H "Content-Type: application/json"',
    \ '-H "Authorization: Bearer ' . g:openai_api_key . '"',
    \ '-d "' . join(l:payload, " ") . '"'
    \ ]
  return join(l:command, " ")
endfunction

" Function responsible for performing the OpenAI API Request
function! PerformOpenAIRequest(prompt)
  let l:json_parser = 'jq -r ".choices[0].message.content"'
  let l:command = BuildOpenAIRequest(a:prompt) . " | " . l:json_parser
  " return split(l:command, "\n")
  return split(system(l:command), "\n")
endfunction

" Function called by popup filter
function! PopupFilter(winid, key)
  if a:key == 'q'
    call popup_close(a:winid)
    return 1
  endif
  if a:key == 'w'
    call popup_close(a:winid)
    call append(line('$'), s:result)
    return 1
  endif
  return 0
endfunction

function! FormatPrompt(prompt)
  return substitute(join(a:prompt, " "), "\"", "'", "g")
endfunction

function! GPT(...)
  let l:popup_settings = {
    \ "filter": "PopupFilter",
    \ "title": "Preview",
    \ "border": [],
    \ "borderchars": ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
    \ "pos": "center",
    \ "minwidth": 80,
    \ "maxwidth": 80,
    \ "minheight": 20,
    \ "maxheight": 20,
    \ }

  let l:prompt = FormatPrompt(a:000)

  call popup_clear()

  let s:result = PerformOpenAIRequest(l:prompt)

  if s:result == ["null"]
    echom "Request Error! Please try again!"
  else
    call popup_create(s:result, l:popup_settings)
  endif
endfunction
