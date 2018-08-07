# kakoune-cscope 0.8
# Author: @dryvenn
# License: MIT

define-command -docstring 'cscope-index [dir]...: index the given directories
Create a cscope index for the given source directories. It is not mandatory to
do so with this command, one can also do it manually.
Will create a cache of the directory names in ./cscope.dirs so that subsequent
invocations can omit them.
Will default to current directory.
    ' \
    -params ..  -file-completion \
    cscope-index %{ evaluate-commands %sh{
        fatal() {
            echo "echo -markup \"{Error}$*\""
            exit
        }

        opts="-R -q -b"
        dirs="$*"
        dirs="${dirs:-$(cat cscope.dirs)}"
        dirs="${dirs:-.}"

        dirs=$(bash -c "echo $dirs")

        [ "$dirs" != "$(cat cscope.dirs)" ] && opts="$opts -u"

        cscope $opts -s $(echo "$dirs" | sed 's/ / -s /g')

        [ $? -ne 0 ] && fatal "Error indexing $dirs"

        echo "$dirs" > cscope.dirs

        echo "echo Indexed $dirs"
    }}

define-command -docstring 'cscope <query> [pattern]: cscope lookup
Query: a digit as below
    0 - Find this C symbol
    1 - Find this function definition
    2 - Find functions called by this function
    3 - Find functions calling this function
    4 - Find this text string
    6 - Find this egrep pattern
    7 - Find this file
    8 - Find files #including this file
    9 - Find assignments to this symbol
Pattern: either supplied or the main selection
    ' \
    -params 1..2 \
    cscope %{ evaluate-commands -try-client %opt{jumpclient} %sh{
        fatal() {
            echo "echo -markup \"{Error}$*\""
            exit
        }

        [ ! -f "cscope.out" ] && fatal "Index not found"

        qry="$1"
        pat=${2:-$(echo "$kak_selection" | awk 'NR==1{print $1}')}

        res="$(cscope -d -L -${qry}${pat})"
        [ $? -ne 0 ] && fatal "Error with query '$qry' and pattern '$pat'"
        [ ! "$res" ] && fatal "No result for query '$qry' and pattern '$pat'"

        printf 'menu -auto-single'
        echo "$res" | while read line
        do
            printf " %%§%-${kak_window_width}.${kak_window_width}s§" "$line"
            echo $line | awk '{printf " %%§edit! %s %s§", $1, $3}'
        done
        echo
}}

define-command -docstring 'cscope-find: cscope function finder' \
    -params 1 \
    -shell-candidates %{ cscope -d -L -1 '.*' |
                            sed -n 's/.*[ :]\([a-zA-Z0-9_]\+\)\s*(.*/\1/p' } \
    cscope-find %{
        cscope 1 %arg{1}
    }

define-command -hidden \
    -params 0..1 \
    cscope-menu %{
        info -title 'Query' \
'0: Find this C symbol
1: Find this function definition
2: Find functions called by this function
3: Find functions calling this function
4: Find this text string
6: Find this egrep pattern
7: Find this file
8: Find files #including this file
9: Find assignments to this symbol'
        on-key %{ cscope %val{key} %arg{1} }
}
