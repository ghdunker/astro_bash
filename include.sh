#!/usr/bin/env bash
Signs_S=("\u2648" "\u2649" "\u264a" "\u264b" "\u264c" "\u264d" "\u264e" "\u264f" "\u2650" "\u2651" "\u2652" "\u2653")

#day order
declare -A planets
planets[sun]="\u2609"
planets[moon]="\u263E"
planets[mercury]="\u263F"
planets[venus]="\u2640"
planets[mars]="\u2642"
planets[jupiter]="\u2643"
planets[saturn]="\u2644"

rs=`./sunrise.sh`

function getRisetime (){
  echo $rs | sed -n -e "s/^\([0-9]*:[0-9]*\).*$/\1/p"
}


function getSettime (){
  echo $rs | sed -n -e "s/^.*\s\([0-9]*:[0-9]*\)$/\1/p"
}



function get_int (){
  echo $1 | sed -n -e "s/\(^[0-9]*\)\..*$/\1/gp"
}

function Norm_Sign () {
  i=$1
  while [[ $i -gt 11 ]];
  do
    let "i=i-12"
  done
  echo $i
}

# To be used with planet and week array

# age, asc
function get_sign (){
s_count=0 
s_age=$1
while :
do 
  let "s_age=s_age-12"
  [[ $s_age -lt 13 ]] && break
done
asc=$2
let "ret_sign=s_age+asc"
ret=`Norm_Sign $ret_sign`
echo $ret
}

# if $1 > $2 return 1, else return 0. (00:00)
function comp_time (){
  h1=`date --date="$1" +%H`
  h2=`date --date="$2" +%H`

  m1=`date --date="$1" +%M`
  m2=`date --date="$2" +%M`
  
  dec_t1=`echo "scale=2; $h1+($m1/60)" | bc -l`
  dec_t2=`echo "scale=2; $h2+($m2/60)" | bc -l`
    Test=`echo "$dec_t1>$dec_t2" | bc -l`
    echo $Test
}

