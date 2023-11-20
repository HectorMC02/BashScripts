#!/bin/bash

function progress_bar {
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
		summod=0
		clear=$(echo "\033[1K\c")
		for (( i=0 ; i<=$1; i++ )) do
			perc="$(echo "scale=2; $temp*100/$1" | bc)% "
			symexactos=$(echo "scale=0; $bpers/1" | bc)
			if (( $(echo "$symexactos == 0" | bc) ))
			then
				mod=$(echo "$bpers % 1" | bc)
			else
				mod=$(echo "$bpers % $symexactos" | bc)
			fi
			if (( $(echo "$i == 0" | bc) ))
			then
				echo -e $clear
				echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
			else
				if (( $(echo "$symexactos > 0" | bc) ))
				then
					sym=$sym$(printf -- '#%.0s' $(seq 1 $symexactos))
					empt=$(echo ${empt%$(printf -- '?%.0s' $(seq 1 $symexactos))})
				fi
				summod=$(echo "$summod+$mod" | bc)
				if (( $(echo "$summod >= 1"| bc) ))
				then
					sym=$sym#
					empt=$(echo ${empt%?})
					summod=$(echo "$summod-1" | bc)
					echo -e $clear
					echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
				else
					if(( $(echo "$i == $1" | bc) && $(echo "$summod > 0"| bc) ))
					then
						sym=$sym#
						empt=$(echo ${empt%?})
						summod=0
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
		echo "Error, el tiempo debe ser mayor a 0 para poder ejecutarse"
	fi
	else
		echo "Error, introduce por consola el tiempo en segundos"
	fi
	echo ''
}
progress_bar $1















