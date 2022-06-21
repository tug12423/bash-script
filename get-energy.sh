#!/bin/bash

rm -f tmp2.dat tmp3.dat tmp.dat tmp4.dat

  for xyz in H C O S Si
  do
  prefix=$xyz
  if [ "$xyz" = "H" ] ; then
    enH=`awk 'END{printf "%15.8f\n", $6}' $xyz/SUMMARY`
    echo $prefix $enH >> total-energy.dat
  elif [ "$xyz" = "C" ] ; then
    enC=`awk 'END{printf "%15.8f\n", $6}' $xyz/SUMMARY`
    echo $prefix $enC >> total-energy.dat
  elif [ "$xyz" = "O" ] ; then
    enO=`awk 'END{printf "%15.8f\n", $6}' $xyz/SUMMARY`
    echo $prefix $enO >> total-energy.dat
  elif [ "$xyz" = "S" ] ; then
    enS=`awk 'END{printf "%15.8f\n", $6}' $xyz/SUMMARY`
    echo $prefix $enS >> total-energy.dat
  elif [ "$xyz" = "Si" ] ; then
    enSi=`awk 'END{printf "%15.8f\n", $6}' $xyz/SUMMARY`
    echo $prefix $enSi >> total-energy.dat
  fi
  done

  rm -f ae.gsic.dat
  for xyz in SiH4 SiO S2 C2H2O2 C3H4 C4H8
  do
  prefix=$xyz
  en1=`awk 'END{printf "%15.8f\n", $6}' $prefix/SUMMARY `
  #tail -1 $prefix/SUMMARY | awk '{printf "%15.8f\n", $6}' > en2   
  if [ "$xyz" = "SiH4" ] ; then
    eb1=`echo "(-$en1 + $enSi + $enH*4.0)*$Ha_Kcal" | bc -l`
  elif [ "$xyz" = "SiO" ] ; then
    eb1=`echo "(-$en1 + $enSi + $enO)*$Ha_Kcal" | bc -l`
  elif [ "$xyz" = "S2" ] ; then
    eb1=`echo "(-$en1 + $enS*2.0)*$Ha_Kcal" | bc -l`
  elif [ "$xyz" = "C2H2O2" ] ; then
    eb1=`echo "(-$en1 + $enC*2.0 + $enH*2.0 + $enO*2.0)*$Ha_Kcal" | bc -l`
  elif [ "$xyz" = "C3H4" ] ; then
    eb1=`echo "(-$en1 + $enC*3.0 + $enH*4.0)*$Ha_Kcal" | bc -l`
  elif [ "$xyz" = "C4H8" ] ; then
    eb1=`echo "(-$en1 + $enC*4.0 + $enH*8.0)*$Ha_Kcal" | bc -l`
  fi
  echo $eb1 >> ae.gsic.dat
  echo $prefix $en1 >> total-energy.dat
  done
  paste ae.gsic.dat ~/work/database/ae6_ref_kcal.dat | awk '{printf "%10.4f\n", $1-$2}' > error.gsic.dat

  paste ae.gsic.dat ~/work/database/ae6_ref_kcal.dat | awk '{print $1-$2,$2}' > tmp.dat
  awk '{if($1<0)$1=-$1}{s+=$1}END{print s/NR}' tmp.dat >> tmp2.dat
  awk '{s+=$1}END{print s/NR}'                 tmp.dat >> tmp3.dat
  awk '{if($1<0)$1=-$1}{s+=($1/$2*100.0)}END{print s/NR}' tmp.dat >> tmp4.dat

echo "#   ind    MAE      ME     MAPE" > mae.gsic.dat
paste tmp2.dat tmp3.dat tmp4.dat > tmp.dat
awk '{printf "%10.4f %10.4f %10.4f\n",$1,$2,$3}' tmp.dat | cat -n >> mae.gsic.dat

rm -f tmp2.dat tmp3.dat tmp.dat tmp4.dat
