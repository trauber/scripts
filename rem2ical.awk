#!/usr/bin/awk -f
# rem2ics by Anthony J. Chivetta <achivetta@gmail.com>
# version 0.1 - 2006-06-09
# Converts output of remind -s to iCalendar
# usage: remind -s | rem2ics
#
# THE FOLLOWING CODE IS RELEASED INTO THE PUBLIC DOMAIN
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
# Tue 10 Mar 2020 05:53:31 PM EDT - Rich Traube
# I added lines 23 to 28 to handle events spanning 00:00
BEGIN {
print "BEGIN:VCALENDAR"
print "VERSION:2.0"
}
{
gsub("/","",$1)
print "BEGIN:VEVENT"
if ($5 != "*"){
printf("DTSTART:%dT%02d%02d00\n",$1,$5/60,$5%60)
min1 = $5%60+$4%60
if (min1 == 60) { min2 = 0 } else { min2 = min1 }
sub(/^7/,"1",min2)
sub(/^8/,"2",min2)
sub(/^9/,"3",min2)
printf("DTEND:%dT%02d%02d00\n",$1,$5/60+$4/60,min2)
print "SUMMARY:" substr($0,match($0,$7))
} else {
printf("DTSTART:%d\n",$1)
print "SUMMARY:" substr($0,match($0,$6))
}
print "END:VEVENT"
}
END {print "END:VCALENDAR"}

