#!/usr/bin/env bash
source ./include.sh
clear

declare -a DAY 
declare -a NIGHT 

declare -a hplanets=("sun" "venus" "mercury" "moon" "saturn" "jupiter" "mars")
# hplanets_i array is the order of the planets through the week 
# from the hplanets array
# for a day, start at hplantest_i[day]
declare -a hplanets_i=(0 3 6 2 5 1 4)

# R   = Rise tmie 
# S   = Set time 
# Tn  = Time Now
# TfR = Time from Rise 
# TfS = Time from set 
# DRS = Interval between Rise and Set 

R=`getRisetime`
S=`getSettime`


cur_l="" # Left part of current time indicator
cur_r="" # Right '' ''

# Must use full date with Z when adding / subtracting time
Rh=`date --date="$R" +%H`
Rm=`date --date="$R" +%M`
DR=`date --date="$R" +%Y-%m-%d\ %R\ %Z`
DS=`date --date="$S" +%Y-%m-%d\ %R\ %Z`
DRS=`date --date="$DS -$Rh hours -$Rm minutes" +%H:%M`
DRS_h=`date --date="$DRS" +%H`

tn=`date +%Y-%m-%d\ %R\ %Z`
tnh=`date --date="$tn" +%H`
tnm=`date --date="$tn" +%M`

# if $tnh:$tnm is greater than 00:00 and < $Rh:$Rm
# then the date is the previous day 
# tn=`date --date="$tn -1 day" +%Y-%m-%d\ %R\ %Z`
# 
if [[ `comp_time $tnh:$tnm 00:00` -eq 1 && `comp_time $tnh:$tnm $Rh:$Rm` -eq 0  ]];
then
  tn=`date --date="$tn -1 day" +%Y-%m-%d\ %R\ %Z`
  echo "Rise Date: $tn"
  day_of_week=`date --date="$tn" +%w`
  echo "day_of_week: $day_of_week"
  echo "late but early"
else
  day_of_week=`date --date="$tn" +%w`
  echo "day_of_week: $day_of_week"
fi

# The night sign is four ahead of the day sign
let "night_of_week_p=day_of_week+4"
night_of_week=`Norm_seven $night_of_week_p`

Sh=`date --date="$S" +%H` # Sunsetet hour
Sm=`date --date="$S" +%M` # Sunset minute
tfR=`date --date="$tn -$Rh hours -$Rm minutes" +%H:%M` # Time from Rise
tfS=`date --date="$DS -$tnh hours -$tnm minutes" +%H:%M` # Time from set


echo "Rise/Set: $R, $S"
echo "Time Now: $tn"
echo "Day length: $DRS"

# DAY array
let "DRS_t=DRS_h+1"

for (( i=0; i<$DRS_t; i++ ))
do 
  DAY+=("`date --date="$DR +$i hour" +%Y-%m-%d\ %R\ %Z`")
done 

# NIGHT array
let "DRR_t=24-DRS_h"
for (( i=0; i<$DRR_t; i++ ))
do 
  NIGHT+=("`date --date="$DS +$i hour" +%Y-%m-%d\ %R\ %Z`")
done

# Is the current DAY/NIGHT hour member the curretn hour?
# Notice the use of eval!
function is_current (){ # Pass the index, the DAY/NIGHT array
  index=$1
  let "next_hour=index+1"
  ARR="$2"
  NEXT_HOUR_ev="date --date=\"\${$ARR[$next_hour]}\" +%R"
  HOUR_ev="date --date=\"\${$ARR[$i]}\" +%R"
  NEXT_HOUR=`eval $NEXT_HOUR_ev`
  HOUR=`eval $HOUR_ev`
  COMP=`comp_time $tnh:$tnm $HOUR`
  COMP_NEXT=`comp_time $tnh:$tnm $NEXT_HOUR`
  if [[ $COMP -eq 1 && $COMP_NEXT -eq 0 || -z $COMP_NEXT ]];
  then
    cur_l="\e[33m"
    cur_r="\e[0m"
  else
    cur_l=""
    cur_r=""
  fi
  echo -e $cur_l$HOUR$cur_r 
}

start_day=$day_of_week # the day (0-6) is to array hplanets_i
start_night=$night_of_week # same idea, just 4 members ahead

echo -e ""

echo "DAY:"
  cur_planet_i=${hplanets_i[$start_day]} # Get index to start in hplanets
for i in ${!DAY[@]}
do 
  P_DAY=`is_current $i "DAY"`
  let "planet=i+cur_planet_i"
  dplanet=`Norm_seven planet`
  cur_planet=${hplanets[$dplanet]}
  echo -e $P_DAY ${planets[$cur_planet]} 
  let "start_day++"
  start_day=`Norm_seven $start_day`
done

echo -e ""

echo "NIGHT:"
  cur_planet_i=${hplanets_i[$start_night]} # Get an index where to start hplanets
for i in ${!NIGHT[@]}
do
  P_NIGHT=`is_current $i "NIGHT"`
  let "planet=i+cur_planet_i"
  dplanet=`Norm_seven planet`
  cur_planet=${hplanets[$dplanet]}
  echo -e $P_NIGHT ${planets[$cur_planet]}
  let "start_night++"
  start_night=`Norm_seven $start_night`
done 
