#!/usr/bin/env bash
# ./loop_Period.sh 1971-03-29 2050-03-29 3
clear
IFS=$'\n' # Field separator is a newline, not a space

Signs_S=("\u2648" "\u2649" "\u264a" "\u264b" "\u264c" "\u264d" "\u264e" "\u264f" "\u2650" "\u2651" "\u2652" "\u2653")

# $1 = start 
# $2 = end

declare -a L1 
declare -a L2 
declare -a L3 

# Return Unicode symbol
function get_sign_part (){
  sign=`echo $1 | sed -n -e "s/^\([0-9]\{,2\}\).*$/\1/gp"`
  echo -e ${Signs_S[$sign]}
}

function get_sign_number (){
echo $1 | sed -n -e "s/^\([0-9]\{,2\}\).*$/\1/gp"
}

function get_date_part (){
  echo $1 | sed -n -e "s/^[0-9]\{,2\}\s\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)/\1/gp"
}




declare a=0
for i in `./Release1.sh $1 $2 $3 L1`
do 
  L1[$a]=$i
  let "a++"
done

a=0 
s_date=0 
e_date=0 
sign=`get_sign_number ${L1[0]}` 

let "L1_length=${#L1[@]}"

for (( sd=0 ; sd<$L1_length; sd++ )) # L1 get start / end dates
do 
  cur_symbol=`get_sign_part $sign`
  #Get date from L[a] to L[a++]
  s_date=`get_date_part ${L1[$sd]}`
  let "ed=sd+1"
  if [[ $sd -eq  $((L1_length-1)) ]];
  then
    e_date=$2 #if at the last L1 member, take end date from second parameter
  else
    e_date=`get_date_part ${L1[$ed]}` #Otherwise the end date is the next L1 member
  fi
  echo $cur_symbol $s_date - $e_date #Display L1 range for curent L1


  # Populate L2 array for the first L1 member
  for l2 in `./Release1.sh $s_date $e_date $sign L2` # L2 
  do 
    L2[$a]=$l2 
    let "a++"
  done





   # Display L2
   for (( i=0; i<${#L2[@]}; i++ ))
   do 
     sign_2=`get_sign_number ${L2[$i]}`
     cur_symbol=`get_sign_part $sign_2`
     cur_date=`get_date_part ${L2[$i]}`
      let "next=i+1"
     next_date=`get_date_part ${L2[$next]}`
     echo -e "\t$cur_symbol $cur_date"
    
     # Fill L3
     if [[  $next_date ]];
     then 
  let "a=0"
    for l3 in `./Release1.sh $cur_date $next_date $sign_2 L3`
    do 
      L3[$a]=$l3
      let "a++"
    done
  let "a=0"
     fi
     # Fill L3 array and print it here.
 # Print L3 --- L3 length == L2 length
 for (( ii=0; ii<${#L3[@]}; ii++ ))
   do 
     sign_3=`get_sign_number ${L3[$ii]}`
     cur_symbol3=`get_sign_part $sign_3`
     cur_date3=`get_date_part ${L3[$ii]}`
      let "next3=ii+1"
     next3_date=`get_date_part ${L3[$next3]}`
     echo -e "\t\t$cur_symbol3 $cur_date3"
# Do L4

     if [[  $next3_date ]];
     then 
  let "a=0"
  echo "Cur date: $cur_date3 next3_date: $next3_date"
    for l4 in `./Release1.sh $cur_date3 $next3_date $sign_3 L4`
    do 
      L4[$a]=$l4
      let "a++"
    done
    echo "L4 size: ${#L4[@]}"
  let "a=0"
     fi

 for (( iii=0; iii<${#L4[@]}; iii++ ))
   do 
     sign_4=`get_sign_number ${L3[$iii]}`
     cur_symbol4=`get_sign_part $sign_4`
     cur_date4=`get_date_part ${L4[$iii]}`
      let "next4=iii+1"
     next4_date=`get_date_part ${L2[$next4]}`
     echo -e "\t\t\t$cur_symbol4 $cur_date4"
   done 
unset L4



   done 

   unset L3
  # Reset L2 counter

   done

   unset L2
 done 
 exit 0
