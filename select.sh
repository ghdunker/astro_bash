#!/usr/bin/env bash
clear 
function get_date_part (){
  echo $1 | sed -n -e "s/^.*\s\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*$/\1/gp"
}

function get_sign_number (){
echo $1 | sed -n -e "s/^\([0-9]\{,2\}\).*$/\1/gp"
}

function get_time_part (){
  echo $1 | sed -n -e "s/^.*\([0-9]\{2\}:[0-9]\{2\}\).*$/\1/gp"
}


Signs_S=("\u2648" "\u2649" "\u264a" "\u264b" "\u264c" "\u264d" "\u264e" "\u264f" "\u2650" "\u2651" "\u2652" "\u2653")

declare -a L1 # Called it L1, but it's the current L array
declare -a Ls
a=0 
range=0
date1=$1
date2=$2
time=""
sign=""
level=1
is_LB="0"

read -p "Enter start-date, end-date, time, sign #: "  date1 date2 time sign
sign_symbol=${Signs_S[$sign]}

clear

IFS=$'\n' # Field separator is a newline, not a space
while [[ $level -le 4 ]]
do
echo -e "$date1 - $date2 $sign_symbol, Level $level, time: $time"

a=0
unset L1

for L in `./Release2.sh $date1 $date2 $sign $level $time`
do 
  L1[$a]=$L 
  let "a++"
done

n_L1=${#L1[@]} # L1 size

echo "L$level:"
for (( i=0; i<$n_L1; i++ ))
do 

    sign_number=`get_sign_number ${L1[$i]}`
    cur_date=`get_date_part ${L1[$i]}`
    wday=`date --date="$cur_date" +%a`
    if [[ $level -ge 3 ]];
    then
    cur_time=`get_time_part ${L1[$i]}`
    fi
  [[ "${L1[$i]}" =~ ^.*LB$ ]] && is_LB="1"
  if [[ $is_LB -eq "1" ]];
  then
    LB="<-- LB"
    lb_left="\e[32m"
    lb_right="\e[0m"
    is_LB=0
  else
    LB=""
    lb_left=""
    lb_right=""
  fi
  echo -e "$lb_left${Signs_S[$sign_number]} $cur_date $cur_time $wday $LB$lb_right"
done

if [[ $level -ge 4 ]];
then 
  exit 0 
fi 

an=1

# While there is a L1_next, make member the current one plus the next
a=0 

while [[ -n ${L1[$an]} && $a -lt n_L1 ]]
do
  date1=`get_date_part ${L1[$a]}`
  date2=`get_date_part ${L1[$an]}`
Ls[$a]="$date1 - $date2"
let "a++"
let "an++"
done

echo -e "\n"
echo -e "Choose Period:"

select s in ${Ls[@]}
do 
range=$s
  break
done

echo $range
let "reply_i=REPLY-1"
let "reply_n=REPLY" 
date1=`get_date_part ${L1[$reply_i]}`
date2=`get_date_part ${L1[$reply_n]}`
sign=`get_sign_number ${L1[$reply_i]}`
let "level++"
clear
done
