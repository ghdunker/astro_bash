#!/usr/bin/env bash
# Quote variable to preserve the new lines returned from astrolog
d1=`date +%b\ %d\ %4Y`
risesets=`/home/gord/Astrolog/astrolog -qd $d1 -z EDT -Yt  -zl  79W26 46N23  _X -Zd -YR 0 10 1 0 1 1 1 1 1 1 1 1 1`
rise=`echo -e "$risesets" | sed -n -e "3p"`
sets=`echo "$risesets" | sed -n -e "8p"`
risetime=`echo $rise | sed -n -e "s/^.*[0-9]\{4\}\s*\([0-9]\{1,2\}:[0-9]\{1,2\}\).*$/\1/p"`
settime=`echo $sets | sed -n -e "s/^.*[0-9]\{4\}\s*\([0-9]\{1,2\}:[0-9]\{1,2\}\).*$/\1/p"`
echo $risetime $settime


