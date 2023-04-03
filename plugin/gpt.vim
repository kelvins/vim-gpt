" Author: Kelvin Salton <http://github.com/kelvins>
" Plugin: https://github.com/kelvins/vim-gpt

let s:envars = environ()

" Global OpenAI variables
let g:openai_model = "gpt-3.5-turbo"
let g:openai_api_key = s:envars["OPENAI_API_KEY"]

let s:openai_url = "https://api.openai.com/v1/chat/completions"

" GPT command must be called with at least 1 argument
command! -nargs=+ GPT call GPT(<f-args>)

" Function responsible for building OpenAI API request
function! BuildOpenAIRequest(prompt)
  let l:payload = [
    \ "{\\\"model\\\": \\\"" . g:openai_model . "\\\",",
    \ "\\\"temperature\\\": 0.7,",
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
  "return split(l:command, "\n")
  return split(system(l:command), "\n")
endfunction

" Function called by popup filter
function! PopupFilter(winid, key)
  if a:key == 'q'
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunction

function! GPT(...)
  " highlight MyPopup ctermfg=black ctermbg=
  let l:popup_settings = {
    \ "filter": "PopupFilter",
    \ "border": [],
    \ "borderchars": ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
    \ "pos": "center",
    \ "minwidth": 80,
    \ "maxwidth": 80,
    \ "minheight": 20,
    \ "maxheight": 20,
    \ }
  let l:prompt = join(a:000, " ")
  call popup_clear()
  let l:result = PerformOpenAIRequest(l:prompt)
  call popup_create(l:result, l:popup_settings)
endfunction
