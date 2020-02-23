#!/bin/bash

tvaddon='a'

a=0
while [ $a -le $LINES ]; do
    b=0
    while [ $b -le $COLUMNS ]; do
	eval 'x'$a'y'$b=0
	b=$(( $b + 1 ))
    done

    a=$(( $a + 1 ))
done


tput cnorm
echo -en "\033[0m"
clear

tput cup 0 0
echo -en "\033[0mName deiner Statistik:\033[0;1m "
read file

tput cup 2 0
echo -en "\033[0m3D, 2 Werte pro Balken [Ja/Nein]:\033[0;1m "
read tv

tput cup 5 0
echo -en "\033[0mAnzahl der Balken:\033[0;1m "
read num

i=0
nob=0
while [ $i -lt $num ]; do

    tput cup $(( $i + 7 )) 0
    echo -en "\033[0mBalken [$(( $i + 1 ))]:\033[0;1m "
    read balken$i
    nowbalk='balken'$i
    
    if [[ "$( cat statlib/name$file$i 2>&1 )" =~ "such" ]] || ( [ "$( cat statlib/name$file$i 2>&1 )" != "${!nowbalk}" ] && [ "${!nowbalk}" != "" ] ); then
	echo "${!nowbalk}" > statlib/name$file$i
    else
	if [ "${!nowbalk}" == "" ]; then
	    declare 'balken'$i="$( cat statlib/name$file$i )"
	fi
    fi
    
    
    if [[ "$( cat statlib/a$file$i 2>&1 )" =~ "such" ]]; then
	echo '0' > statlib/a$file$i
    fi

    if [[ "$( cat statlib/b$file$i 2>&1 )" =~ "such" ]]; then
	echo '0' > statlib/b$file$i
    fi
    
    i=$(( $i + 1 ))
    nob=$(( $nob + 1 ))
done

tput civis

clear

command=''

load='all'
mustload=0

while [ true ]; do

        
    if [ "$command" == "a" ]; then
	echo -en "\033[0m"
	clear
	
	tput cup 0 $(( $COLUMNS - ${#file} ))
	echo -en "\033[0;4m$file\033[0m"
	
	if [ "$tv" != "Ja" ]; then
	    tput cup 0 0
	    echo -en "\033[0;1mDescription\033[0m"
	    tput cup 0 20
	    echo -en "\033[0;1mValues\033[0m"
	    
	    echo "Description,Value" > statdocuments/$file.csv
	    
	    i=0
	    while [ $i -lt $num ]; do
		nowbalk='balken'$i
		nowbalkwerta=$( cat statlib/a$file$i )
		
		echo "${!nowbalk},$nowbalkwerta" >> statdocuments/$file.csv
		
		tput cup $(( $i + 1 )) 0
		echo -en "\033[0m${!nowbalk}\033[0m"
		tput cup $(( $i + 1 )) 20
		echo -en "\033[0m$nowbalkwerta\033[0m"
		
		i=$(( $i + 1 ))
	    done
	else
	    tput cup 0 0
	    echo -en "\033[0;1mDescription\033[0m"
	    tput cup 0 20
	    echo -en "\033[0;1mValues_A\033[0m"
	    tput cup 0 40
	    echo -en "\033[0;1mValues_B\033[0m"
	    
	    echo "Description,Values_A,Values_B" > statdocuments/$file.csv
	    
	    i=0
	    while [ $i -lt $num ]; do
		nowbalk='balken'$i
		nowbalkwerta=$( cat statlib/a$file$i )
		nowbalkwertb=$( cat statlib/b$file$i )
		
		echo "${!nowbalk},$nowbalkwerta,$nowbalkwertb" >> statdocuments/$file.csv
		
		tput cup $(( $i + 1 )) 0
		echo -en "\033[0m${!nowbalk}\033[0m"
		tput cup $(( $i + 1 )) 20
		echo -en "\033[0m$nowbalkwerta\033[0m"
		tput cup $(( $i + 1 )) 40
		echo -en "\033[0m$nowbalkwertb\033[0m"
		
		i=$(( $i + 1 ))
	    done
	fi
	
	nothing=$( libreoffice --calc statdocuments/$file.csv 2>&1 > /dev/null )

	load="all"
	mustload=1
	
	clear
    fi
    

    
    if [ "$command" == "q" ]; then
	echo -en "\033[0m"
	clear
	tput cnorm
	break;
    fi
    
    if [ "$command" == "c" ]; then
	clear
	load='all'
    fi

    if [ "$command" == "1" ]; then
	tvaddon='a'
    fi
    if [ "$command" == "2" ] && [ "$tv" == "Ja" ]; then
	tvaddon='b'
    fi
    
    if [ "$command" == "w" ]; then
	i=0
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=0
    fi
    if [ "$command" == "s" ]; then
	i=0
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=0
    fi

    if [ "$command" == "e" ]; then
	i=1
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=1
    fi
    if [ "$command" == "d" ]; then
	i=1
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=1
    fi

    if [ "$command" == "r" ]; then
	i=2
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=2
    fi
    if [ "$command" == "f" ]; then
	i=2
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=2
    fi

    if [ "$command" == "t" ]; then
	i=3
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=3
    fi
    if [ "$command" == "g" ]; then
	i=3
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=3
    fi

    if [ "$command" == "z" ]; then
	i=4
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=4
    fi
    if [ "$command" == "h" ]; then
	i=4
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=4
    fi

    if [ "$command" == "u" ]; then
	i=5
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=5
    fi
    if [ "$command" == "j" ]; then
	i=5
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=5
    fi

    if [ "$command" == "i" ]; then
	i=6
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=6
    fi
    if [ "$command" == "k" ]; then
	i=6
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=6
    fi

    if [ "$command" == "o" ]; then
	i=7
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=7
    fi
    if [ "$command" == "l" ]; then
	i=7
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=7
    fi
    
    if [ "$command" == "p" ]; then
	i=8
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=8
    fi
    if [ "$command" == "ö" ]; then
	i=8
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=8
    fi
    
    if [ "$command" == "ü" ]; then
	i=9
	echo $(( $( cat statlib/$tvaddon$file$i ) + 1 )) > statlib/$tvaddon$file$i
	load=9
    fi
    if [ "$command" == "ä" ]; then
	i=9
	echo $(( $( cat statlib/$tvaddon$file$i ) - 1 )) > statlib/$tvaddon$file$i
	load=9
    fi

    if [ $mustload -eq 1 ]; then
	load="all"
    fi
    
    i=0
    while [ $i -lt $num ] && [ "$tv" != "Ja" ]; do
	if [ "$load" == "$i" ] || [ "$load" == "all" ]; then
	    nowbalk='balken'$i
	    
	    if [ $(( ( $COLUMNS / $nob ) - 7 )) -le 10 ]; then
		nowbalklenght=$(( ( $COLUMNS / $nob ) - 7 ))
	    else
		nowbalklenght=10
	    fi
	    
	    nowbalkwerta=$( cat statlib/a$file$i )
	    tput cup $LINES $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    b=0
	    while [ $nowbalklenght -gt $b ]; do
		echo -en "\033[44m \033[0m"
		b=$(( $b + 1 ))
	    done
	    tput cup $LINES $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    echo -en "\033[0;44m"${!nowbalk}
	    
	    tput cup $(( $LINES - 2 )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    b=0
	    while [ $nowbalklenght -gt $b ]; do
		echo -en "\033[41m \033[0m"
		b=$(( $b + 1 ))
	    done
	    tput cup $(( $LINES - 2 )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    echo -en "\033[0;41m"$nowbalkwerta"\033[0m\n"
	    
	    b=0
	    while [ $b -lt $LINES ]; do
		
		if [ $(( $LINES - 3 - $b )) -ge 0 ]; then
		    tput cup $(( $LINES - 3 - $b )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
		fi
		
		if [ $b -lt $nowbalkwerta ]; then
		    c=0
		    while [ $nowbalklenght -gt $c ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=1
			echo -en "\033[42m \033[0m"
			c=$(( $c + 1 ))
		    done
		else
		    c=0
		    while [ $nowbalklenght -gt $c ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=0
			echo -en " "
			c=$(( $c + 1 ))
		    done
		fi
		
	    	
		b=$(( $b + 1 ))
	    done
	    
	fi
	i=$(( $i + 1 ))
	    
    done


    i=0
    while [ $i -lt $num ] && [ "$tv" == "Ja" ]; do
	if [ "$load" == "$i" ] || [ "$load" == "all" ]; then
	    nowbalk='balken'$i
	    
	    if [ $(( ( $COLUMNS / $nob ) - 7 )) -le 10 ]; then
		nowbalklenght=$(( ( $COLUMNS / $nob ) - 7 ))
	    else
		nowbalklenght=10
	    fi

	    tvlenght=$(( $nowbalklenght / 2 ))
	    
	    
	    nowbalkwerta=$( cat statlib/a$file$i )
	    nowbalkwertb=$( cat statlib/b$file$i )
	    tput cup $LINES $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    b=0
	    while [ $nowbalklenght -gt $b ]; do
		echo -en "\033[44m \033[0m"
		b=$(( $b + 1 ))
	    done
	    tput cup $LINES $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    echo -en "\033[0;44m"${!nowbalk}
	    
	    tput cup $(( $LINES - 2 )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    b=0
	    while [ $nowbalklenght -gt $b ]; do
		echo -en "\033[41m \033[0m"
		b=$(( $b + 1 ))
	    done
	    tput cup $(( $LINES - 2 )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
	    echo -en "\033[0;41m"$nowbalkwerta / $nowbalkwertb"\033[0m\n"
	    
	    b=0
	    while [ $b -lt $LINES ]; do
		
		if [ $(( $LINES - 3 - $b )) -ge 0 ]; then
		    tput cup $(( $LINES - 3 - $b )) $(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 ))
		fi
		
		if [ $b -lt $nowbalkwerta ]; then
		    c=0
		    while [ $tvlenght -gt $c ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=1
			echo -en "\033[42m \033[0m"
			c=$(( $c + 1 ))
		    done
		else
		    c=0
		    while [ $tvlenght -gt $c ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=0
			echo -en " "
			c=$(( $c + 1 ))
		    done
		fi

		if [ $b -lt $nowbalkwertb ]; then
		    c=$tvlenght
		    while [ $nowbalklenght -gt $c ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=2
			echo -en "\033[47m \033[0m"
			c=$(( $c + 1 ))
		    done
		else
		    c=$tvlenght
		    while [ $nowbalklenght -gt $c ] && [ "$tv" == "Ja" ]; do
			eval 'x'$b'y'$(( ( ( $COLUMNS / $nob ) * ( $i ) ) + 5 + $c ))=0
			echo -en " "
			c=$(( $c + 1 ))
		    done
		fi
		
	    	
		b=$(( $b + 1 ))
	    done
	    
	fi
	i=$(( $i + 1 ))
	    
    done

    tput cup 0 $(( $COLUMNS - ${#file} ))
    echo -en "\033[0;4m$file\033[0m"
	
    read -sn1 command

    mustload=0
    
    if [ "$command" == "#" ]; then
	
	i=0
	while [ $i -lt $(( $LINES - 2 )) ]; do
	    if [ $(( $i - 1 )) -eq 1 ] || [ $(( $i - 1 )) -eq 5 ] || [ $(( $i - 1 )) -eq 10 ] || [ $(( $i - 1 )) -eq 15 ] || [ $(( $i - 1 )) -eq 20 ] || [ $(( $i - 1 )) -eq 25 ] || [ $(( $i - 1 )) -eq 30 ] || [ $(( $i - 1 )) -eq 35 ] || [ $(( $i - 1 )) -eq 40 ] || [ $(( $i - 1 )) -eq 45 ] || [ $(( $i - 1 )) -eq 50 ] || [ $(( $i - 1 )) -eq 55 ] || [ $(( $i - 1 )) -eq 60 ] || [ $(( $i - 1 )) -eq 65 ] || [ $(( $i - 1 )) -eq 70 ] || [ $(( $i - 1 )) -eq 75 ] || [ $(( $i - 1 )) -eq 80 ] || [ $(( $i - 1 )) -eq 85 ] || [ $(( $i - 1 )) -eq 90 ] || [ $(( $i - 1 )) -eq 95 ] || [ $(( $i - 1 )) -eq 100 ]; then 
		b=0
		while [ $b -lt $COLUMNS ]; do
		    tput cup $((( $LINES - 2 ) - $i )) $b	
		    
		    posval='x'$(( $i - 1 ))'y'$b
		    if [ "${!posval}" == '1' ]; then
			echo -e "\033[0;4;42m "
		    elif [ "${!posval}" == '2' ]; then
			echo -e "\033[0;4;47m "
		    else
			echo -e "\033[0;4m "
		    fi
		    
		    echo -e "\033[0;34m $(( $i - 1 ))"
	    	    b=$(( $b + 1 ))
		done
	    fi
	    
	    i=$(( $i + 1 ))
	done
	read -sn1 command
	load='all'
	mustload=1
	clear
    fi

done
