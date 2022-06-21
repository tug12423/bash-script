#!/bin/bash

rm -f pref conv
[ -e enfile ] && rm -f enfile

for xyz in *.xyz

do

prefix=${xyz/.xyz/}

if [ -e $prefix/fande.out ]
then
  echo $prefix >> pref
  awk '{printf "%15.8f %15.4e \n", $2,$3}' $prefix/fande.out|tail -1 >> enfile

tt=`awk '{printf "%10.8f\n", $2} ' $prefix/SUMMARY | tail -2 |head -1`
t=`awk '{printf "%10.8f\n", $2} ' $prefix/SUMMARY | tail -1`
mf=`awk '{printf "%10.8f\n", $3}' $prefix/fande.out | tail -1`
de=`awk '{printf "%10.8f \n", $2-p} {p=$2}' $prefix/fande.out|tail -1`
de=$( echo $de | tr -d -)
 #
  #check force and energy convergence as defined above
 if (( $(echo "$mf<$ftol" | bc -l) && $(echo "$de<$etol" | bc -l) && $(echo "$tt<$z" | bc -l) && $(echo "$t==$z" | bc -l) )); then
      echo 'converged' $tt>> conv
  else
      echo 'not-converged' >> conv
  fi
else
  echo $prefix/fande.out does not exist
  echo $prefix >> pref
  echo 0.0 0.0 0.0 >> enfile
  echo 'not-exist' >> conv
fi
done

paste pref enfile conv | awk '{printf "%20s %15.8f %15.4e  %30s %15.8f\n", $1,$2,$3,$4,$5}' > convergence.dat
rm -f pref enfile conv
