#!/usr/bin/bash

# Use remind and timeblok to create ical files with 
# descriptions. Only does full day events.

# Requires rust, cargo, remind.
# Usage: rembloks <file>.rem
#
# Outputs ical to out.ics



# Rich Traube, 2024-06-17


file_in="$1"

###########################################################
# Convert output of remind -s to timeblock format.        #
# Output to file since timeblock doesn't read from stdin. #
###########################################################

rem2tb()  {
    previous_year="00"
    previous_month="01"
    previous_day="00"

    echo "/region US"

    while read line
    do
        year=$(echo "$line" | cut -d"/" -f1)
        month=$(echo "$line" | cut -d"/" -f2)
        day=$(echo "$line" | cut -d"/" -f3 | cut -d" " -f1)
        note=$(echo "$line" | cut -d" " -f6-)
        last_word=$(echo "$line" | rev | cut -d" " -f1 | rev)

        [ "$year" -ne "$previous_year" ] && echo "$year-01-"

        [ "$month" -ne "$previous_month" ] && echo "-$month-"

        if [ "$day" -ne "$previous_day" ]
        then
            echo -n "--$day "

            if [[ "$last_word" =~ ^.*\.txt$ ]]
            then
                note=$(echo "$note" | sed 's/'"$last_word"'//')
                echo "$note"
                cat "$last_word"
            else
                echo "$note"
            fi
        fi

        

        previous_year=$year
        previous_month=$month
        previous_day=$day

    done < <(remind  -s -c36 -f "$file_in")

} > tmp.txt

#########################################################################
# Render ical from timeblok. Output has to go to file. The output needs #
# some string filtering to enable forward slashes. That's the only case #
# I've found so far, not that I'm being rigorous.                       #
#########################################################################

tb2ics() {
    sed -i 's%:\/\/%:\\/\\/%g' tmp.txt
    timeblok tmp.txt -f out.ics
    sed -i 's%:\\\/\\\/%//%g' out.ics
}


rem2tb 
tb2ics
