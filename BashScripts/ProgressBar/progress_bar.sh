#!/bin/bash
if (( $(echo "$# == 1" | bc) ))
then
if (( $(echo "$1 > 0" | bc) ))
then
	default=60
	sym=''
	empt='-'
	temp=0
	bpers=$(echo "scale=2; $default/$1" | bc)
	empt=$(printf -- '-%.0s' $(seq 1 $default))
	addmod=0
	clear=$(echo "\033[1K\c")
	for (( i=0 ; i<=$1; i++ )) do
		perc="$(echo "scale=2; $temp*100/$1" | bc)% "
		exacsym=$(echo "scale=0; $bpers/1" | bc)
		if (( $(echo "$exacsym == 0" | bc) ))
		then
			mod=$(echo "$bpers % 1" | bc)
		else
			mod=$(echo "$bpers % $exacsym" | bc)
		fi
		if (( $(echo "$i == 0" | bc) ))
		then
			echo -e $clear
			echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
		else
			if (( $(echo "$exacsym > 0" | bc) ))
			then
				sym=$sym$(printf -- '#%.0s' $(seq 1 $exacsym))
				empt=$(echo ${empt%$(printf -- '?%.0s' $(seq 1 $exacsym))})
			fi
			addmod=$(echo "$addmod+$mod" | bc)
			if (( $(echo "$addmod >= 1"| bc) ))
			then
				sym=$sym#
				empt=$(echo ${empt%?})
				addmod=$(echo "$addmod-1" | bc)
				echo -e $clear
				echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
			else
				if(( $(echo "$i == $1" | bc) && $(echo "$addmod > 0"| bc) ))
				then
					sym=$sym#
					empt=$(echo ${empt%?})
					addmod=0
				echo -e $clear
					echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
				fi
				echo -e $clear
				echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
			fi
		fi
		temp=$((temp+1))
		sleep 1
	done
else
	echo "Error, the time must be greater than 0"
fi
else
	echo "Error, introduce the time in seconds as a parameter"
fi
echo ''















