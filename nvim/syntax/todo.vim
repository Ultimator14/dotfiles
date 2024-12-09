" Vim syntax file
" Language: Todo
" Maintainer: Huy Tran
" Latest Revision: 14 June 2020

if exists("b:current_syntax")
  finish
endif

" Custom conceal
syntax match todoCheckbox "\[\ \]" conceal cchar=󰄱
syntax match todoCheckbox "\[x\]" conceal cchar=󰄲

let b:current_syntax = "todo"

highlight default link todoCheckbox Todo
highlight Conceal guibg=NONE

setlocal cole=1
