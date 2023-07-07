#!/usr/bin/env bash

if [[ $# -eq 0 ]];
then 
  echo "Usage: Start (YYYY-MM-DD) End (YY-MM-DD) Start_Sign (0-11) Period (L1, L2, L3)"
  exit 0 
fi

Loose=0
fmt="+%Y-%m-%d"

Signs=("Ari" "Tau" "Gem" "Can" "Leo" "Vir" "Lib" "Sco" "Sag" "Cap" "Aqu" "Pis")

# L1 period Years = 360*periods_1[n]
# L2 period months = 30*periods_1[n]
# L3 period weeks = 2.5*periods_1[n]
# L4 period days = 5*periods_1[n]
# Example: L3, Cpri --> 27*2.5 = 67.5 days (2 months, 7 days, 12 hours)
#          L4, ARI -->  15*5 = 3.125 days (3 days 3 hours)
periods_1=(15 8 20 25 19 20 8 15 12 27 30 12)  

Signs_S=("\u2648" "\u2649" "\u264a" "\u264b" "\u264c" "\u264d" "\u264e" "\u264f" "\u2650" "\u2651" "\u2652" "\u2653")

Cur_Date=0
Cur_I=0 # Index used for both Sign and Period
Cur_M=30 # Cur_M is either 30 or 360 days

# Return extended index value of Signs
function Norm_Sign () {
  i=$1
  while [[ $i -gt 11 ]];
  do
    let "i=i-12"
  done
  echo $i
}

# Return opposite sign
function Loose () { 
  let "s_add=$1+6"
  s_add=`Norm_Sign $s_add`
  echo $s_add
}


# Returns array of periods given start_date, end_date, init_sign cur_m
function Make_Periods () {
  Cur_M=$4
  time=$5
  start_date=$1
  end_date=$2
  sd_n=`date --date="$start_date $time" +%s` 
  ed_n=`date --date="$end_date" +%s`
  init_sign=$3
  #let "Cur_delta_t=${periods_1[$3]}*${Cur_M}"
  init_p=1 # Tells loop to ignore $sign -eq $3 so it doesn't call Loose right away
  LB="" #Loosing of the Bonds indicator
  LB_flag=0


  # call ./get_L_time.sh period Level here:
  # d=`date --date="1971-03-29 09:00 $d1" +%Y-%m-%d\ %H:%S`
  # Needs the UT value to be accurate, but the format in the for statement
  # is formated in one string: 19711014 therefore, 19711014 13:00 breaks this!
  # convert the date to seconds (date --date"=1971-03-29 13:00" +%s)
  # convert it back: date --date='@39117600' +%Y-%m-%d
  for (( i_date=$sd_n; i_date<$ed_n; ))
  do
    sign=`Norm_Sign $init_sign`
    init_sign=$sign
    #LB
    if [[ $sign -eq $3 && $init_p -eq 0 && $LB_flag -eq 0 ]];
    then
      sign=`Loose $sign`
      init_sign=$sign
      LB_flag=1
      LB="LB"
    fi
    date_from_S=`date --date="@${i_date}" +%Y-%m-%d\ %R`
    date_from_S_UT=`date --date="$date_from_S" +%Y-%m-%d\ %R`

    echo -e "$sign `date --date="$date_from_S_UT" +%Y-%m-%d\ %R` $LB"
    LB=""

    # let "Cur_delta_t=periods_1[sign]*Cur_M"
    Cur_delta_t=`./get_L_time.sh $sign $Cur_M`
    let "init_sign++"
    init_p=0
    # increment i_date
    i_date=`date --date="$date_from_S_UT $Cur_delta_t" +%Y-%m-%d\ %R`
    #put date back to seconds
    i_date=`date --date="$i_date" +%s`
  done

}
Make_Periods $1 $2 $3 $4 $5



