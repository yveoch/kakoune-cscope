# kakoune-cscope 0.1
# Author: @dryvenn
# License: MIT

declare-option -hidden str-list cscope_files 'cscope.out'

define-command -docstring 'cscope-add <file>: add an index to the list' \
        -params 1 -file-completion \
        cscope-add %{
                set-option global cscope_files %sh{
                echo $kak_opt_cscope_files:$1 | tr ':' '\n' |
                sort -u | xargs readlink -e | paste -sd ':'
            }
        }

define-command -docstring 'cscope-build <dir>: build an index and add it' \
        -params 1 -file-completion \
        cscope-build %{ %sh{
                if [ ! -d "$1" ]
                then
                        printf "fail %s" "Not a directory!"
                fi
                cd $1
                cscope -R -q -u -b
                printf "cscope-add %s" $1/cscope.out
        }}

define-command -docstring 'cscope-clear: clear the index list' \
        cscope-clear %{
                set-option global cscope_files ''
        }

define-command -docstring 'cscope-find <query> [pattern]: find using cscope indexes
Query:
  0 - Find this C symbol
  1 - Find this function definition
  2 - Find functions called by this function
  3 - Find functions calling this function
  4 - Find this text string
  6 - Find this egrep pattern
  7 - Find this file
  8 - Find files #including this file
  9 - Find assignments to this symbol

Pattern:
  depends on the query, either specified or the current selection
' \
        -params 1..2 \
        cscope-find %{ %sh{
                query=$1
                pattern=${2:-${kak_selection}}
                result=$(echo $kak_opt_cscope_files | tr ':' '\n' |
                while read file
                do
                        cscope -R -q -f $file -L$query $pattern
                done)
                if [ ! "$result" ]
                then
                        printf 'fail %s' "No match!"
                        exit 1
                fi
                result=$(echo "$result" | fzf-tmux -d 20% -- -1 -0)
                file=$(echo $result | cut -d ' ' -f 1)
                line=$(echo $result | cut -d ' ' -f 3)
                printf "edit! %s %s" "$file" "$line"
        }}
