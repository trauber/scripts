#!/usr/bin/awk -f
# 
# eyu.awk - Echo Your Usage. Wrap usage text lines in echo " " with space padding to a max length.
# Rich Traube - Tue 10 Mar 2020 05:09:13 PM EDT
#

BEGIN {
  maxlinelength=80
}

{
  gsub(/"/,"\\\"",$0)                              # ... in case usage text includes any double quotes.
  linelength = length($0)                          # Get line length. Gotta love awk.
  paddingcount = maxlinelength - linelength - 4    # Calculate spaces to be appended. Next line prepends 4 spaces to each line.
  printf "echo \"    " $0
  s=sprintf("%" paddingcount "s","");print s "\""  # Variable paddingcount is read into the sprintf directive.
}



