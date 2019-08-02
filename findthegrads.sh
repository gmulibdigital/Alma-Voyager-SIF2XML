#!/bin/sh
# make a backup of the HR file
cp vgrgmuhr.dat vgrgmuhr.was
# first extract all gnumbers if medm is in the code (e.g., ro medm)
awk '{ if ($3 =="medm") { print $ 8}}' < vgrgmustu.dat > grads.txt
# now, find all the wages people in the HR file (e.g., po ireg)
awk '{ if ($3 =="ireg") { print $ 8}}' < vgrgmuhr.dat > wages.txt
# now, find out which G numbers are in both files (grad students as wages)
awk -F\| 'NR==FNR{a[$1]++;next}a[$1]'  grads.txt wages.txt > wage-grads.txt
# now if the G number isn't in the grads file, write it to a new wages file
grep -vf wage-grads.txt vgrgmuhr.dat > vgrgmuhr.out
# rename the *out file to vgrgmuhr.dat
mv vgrgmuhr.out vgrgmuhr.dat

