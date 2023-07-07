#!/usr/bin/env bash

# Return format for L3 

# L1 period Years = 360*periods_1[n]
# L2 period months = 30*periods_1[n]
# L3 period weeks = 2.5*periods_1[n]
# L4 period days = 5*periods_1[n]
# Example: L3, Cpri --> 27*2.5 = 67.5 days (2 months, 7 days, 12 hours)
#          L4, ARI -->  15*5 = 75 hours =  3.125 days (3 days 3 hours)

periods_1=(15 8 20 25 19 20 8 15 12 27 30 12)  
period=${periods_1[$1]}
days=0
years=0
months=0
hours=0
days_part=0 
days_float=0 
month_count=0
L=$2

# Get integer without decimal
function get_int (){ 
  echo $1 | sed -n -e "s/^\([0-9]*\)\..*$/\1/gp"
}

# Get the decimal part
function get_float(){
  echo $1 | sed -n -e "s/^[0-9]*\(\..*\)$/\1/gp"
}


function init_days(){
  days_part=`get_int $days`
  days_float=`get_float $days`
}

case $L in 
  1)
    let "years=$period*360"
    echo "$years days"
    exit 0
    ;;
    

  2)
    months=$period
    let "days=months*30"
    echo "$days days"
    exit 0
    ;;

  3)
    days=`echo "${period}*2.5" | bc -l`
    init_days
    hours_part=0
    int=$days_part
    # Reduce months > 12 to years

  # Reduce days > 30 to number of months
  while [[ $int -gt 30 ]];
  do 
    let "int=int-30"
    let "month_count++"
  done
  hours_float=`echo "$days_float*24" | bc -l`

  if [[ $days_float = ".0" || $days_float = "0" ]];
  then
    hours_part=0
  else
    hours_part=`get_int $hours_float`
  fi

  if [[ $month_count -eq 0 ]];
  then
  echo "$int days"
else 
  echo "$days_part days $hours_part hours"
  fi
  exit 0
  ;;


4)
  days=`echo "${period}*5.0" | bc -l`
  days_count=0
  init_days

  while [[ $days_part -gt 24 ]];
  do 
    let "days_part=days_part-24"
    let "days_count++"
  done
  # This looks confusing: day_part is the number of hours left over
  echo "$days_count days $days_part hours"
  exit 0
  ;;
*)
  echo "Need a level"
  exit 1 
  ;;
esac
# format_L $days_part $days_float
#TZ="America/Toronto" date --date="1971-03-29 09:00 `./get_L3_time.sh 3 L2`"

