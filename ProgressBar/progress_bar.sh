#!/bin/bash

function progress_bar {
	#Para hacer el porcentaje tomar el tiempo total ($1) siendo eso el 100%, hacer una regla de 3 avanzando a medida que baje el tiempo
	if (( $(echo "$# == 1" | bc) ))
	then
	if (( $(echo "$1 > 0" | bc) ))
	then
		default=60 #cantidad por defecto del tamaño de la barra de carga
		sym='' #cantidad completada
		empt='-' #cantidad no completada
		temp=0
		bpers=$(echo "scale=2; $default/$1" | bc) #blocks per second
		empt=$(printf -- '-%.0s' $(seq 1 $default)) #relleno empt con todos los "vacios"
		summod=0
		clear=$(echo "\033[1K\c")
		for (( i=0 ; i<=$1; i++ )) do
			perc="$(echo "scale=2; $temp*100/$1" | bc)% "
			symexactos=$(echo "scale=0; $bpers/1" | bc) #calculo de los simbolos exactos (si 2 --> 2/5 --> 2.5 --> symexactos = 2)
			if (( $(echo "$symexactos == 0" | bc) ))
			then
				mod=$(echo "$bpers % 1" | bc)
			else	
				mod=$(echo "$bpers % $symexactos" | bc) #sobrante de symexactos, para el caso anterior 0.5
			fi
			if (( $(echo "$i == 0" | bc) ))
			then
				echo -e $clear
				echo -ne "\r$perc$sym$empt $(($1-$temp)) secs" #no avanza debido a que sym esta vacio
			else
				if (( $(echo "$symexactos > 0" | bc) ))
				then
					sym=$sym$(printf -- '#%.0s' $(seq 1 $symexactos)) #ponemos la cantidad de sym que tocan
					empt=$(echo ${empt%$(printf -- '?%.0s' $(seq 1 $symexactos))}) #ponemos los "vacios" que toquen
				fi
				summod=$(echo "$summod+$mod" | bc) #suma de los mod que sobran
				if (( $(echo "$summod >= 1"| bc) ))
				then
					sym=$sym#
					empt=$(echo ${empt%?})
					summod=$(echo "$summod-1" | bc) #quitamos uno para mostrarlo
					echo -e $clear
					echo -ne "\r$perc$sym$empt $(($1-$temp)) secs"
				else
					if(( $(echo "$i == $1" | bc) && $(echo "$summod > 0"| bc) ))
					then
						sym=$sym#
						empt=$(echo ${empt%?})
						summod=0 #vaciamos summod
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















