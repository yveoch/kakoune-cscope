# kakoune-cscope 0.2
# Author: @dryvenn
# License: MIT

define-command -docstring 'cscope-index <dir>...: index the given directories
Create a cscope index for the given source directories. It is not mandatory to
do so with this command, one can also do it manually.
        ' \
        -params 1..  -file-completion \
        cscope-index %{ %sh{
                [ $# == 0 ] && dirs="." || dirs="$*"
                cscope -R -q -u -b -s $(echo "$dirs" | sed 's/ / -s /g')
        }}

define-command -docstring 'cscope [query] [pattern]: cscope lookup
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
        -params ..2 \
        cscope %{ %sh{
            fatal() {
                echo "echo -markup \"{Error}$*\""
                exit
            }
            pad_as_line() {
                printf "%-${kak_window_width}.${kak_window_width}s" "$*"
            }

            if [ $# == 1 ]
            then
                if [ $(expr length "$1") == 1 ]
                then
                    cmd="$1"
                else
                    qry="$1"
                fi
            elif [ $# == 2 ]
            then
                cmd="$1"
                qry="$2"
            fi

            qry=${qry:-$(echo "$kak_selection" | awk 'NR==1{print $1}')}
            [ ! "$qry" ] && fatal 'No query'

            if [ ! "$cmd" ]
            then
                echo menu \
                "\"$(pad_as_line '0 - Find this C symbol                    ')\"" "\"cscope 0 $qry\"" \
                "\"$(pad_as_line '1 - Find this function definition         ')\"" "\"cscope 1 $qry\"" \
                "\"$(pad_as_line '2 - Find functions called by this function')\"" "\"cscope 2 $qry\"" \
                "\"$(pad_as_line '3 - Find functions calling this function  ')\"" "\"cscope 3 $qry\"" \
                "\"$(pad_as_line '4 - Find this text string                 ')\"" "\"cscope 4 $qry\"" \
                "\"$(pad_as_line '6 - Find this egrep pattern               ')\"" "\"cscope 6 $qry\"" \
                "\"$(pad_as_line '7 - Find this file                        ')\"" "\"cscope 7 $qry\"" \
                "\"$(pad_as_line '8 - Find files #including this file       ')\"" "\"cscope 8 $qry\"" \
                "\"$(pad_as_line '9 - Find assignments to this symbol       ')\"" "\"cscope 9 $qry\""
                exit
            fi

            res="$(cscope -d -L -${cmd}${qry})"
            [ ! "$res" ] && fatal 'No result' $cmd $qry

            printf 'menu -auto-single'
            echo "$res" | while read line
            do
                printf " \"$(pad_as_line %s)\"" "$line"
                echo $line | awk '{printf " \"edit! %s %s\"", $1, $3}'
            done
            echo
    }}
