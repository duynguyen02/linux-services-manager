#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`
blue=`tput setaf 4`
yellow=`tput setaf 3`

SERVICES=("apache2" "mysqld" "pulseaudio")
SERVICES_NAME=("Apache2" "MySQL" "Pulseaudio")

get_service_status(){
	SERVICE_STATUS=`pidof ${1}`

	if [ -z "$SERVICE_STATUS"  ]
	then
		SERVICE_STATUS_SYMBOL=`echo "[${red}✗${reset}]"`
	else
		SERVICE_STATUS_SYMBOL=`echo "[${green}✓${reset}]"`
	fi

	echo "[${2}][${3}]${SERVICE_STATUS_SYMBOL}"

}

list_services_status(){
	COUNT=0

	for SERVICE in "${SERVICES[@]}"
	do
		get_service_status $SERVICE $COUNT ${SERVICES_NAME[${COUNT}]}
		COUNT=`expr $COUNT + 1`

	done
}

exit_program(){
	echo "[${cyan}---GOOD BYE!---${reset}]"
	exit
}

invalid_key_error(){
	clear
	echo "[${red}✗${reset}] Invalid key!"
}



echo "[${cyan}---SERVICES MANAGER---${reset}]"
# echo "[${blue}?${reset}] Enter your password: "


# read -s USER_PASSWORD

# TEST=`echo ${USER_PASSWORD} | sudo -S ls`

sudo -v

if [ "$?" == 1 ]
then
	echo "[${red}✗${reset}] Invalid password!"
	exit
fi


clear
echo "[${cyan}---WELCOME TO SERVICES MANAGER---${reset}]"

# get_service_status "apache2" "1" "Apache2";

# get_service_status "mysqld" "2" "MySQL";

# get_service_status "pulseaudio" "3" "Pulseaudio";

echo

while :
do
	list_services_status
	echo
	echo "[${blue}?${reset}] Please enter a service key that you want to config:(q: quit)"

	read SERVICE_KEY

	if [[ $SERVICE_KEY =~ ^[a-zA-Z]*$ ]];
	then
		if [ $SERVICE_KEY == 'q' ]
		then
			exit_program
		else
			invalid_key_error
			continue
		fi
	fi


	if [ $SERVICE_KEY -gt ${#SERVICES[@]} ] || [ $SERVICE_KEY -lt 0 ] || [ $SERVICE_KEY -eq ${#SERVICES[@]} ]
	then
		invalid_key_error
		continue
	fi

	clear

	CURRENT_SER_STATUS=`get_service_status '${SERVICES[$SERVICE_KEY]' '' ''`

	echo "[${blue}?${reset}] You are choosing ${SERVICES_NAME[$SERVICE_KEY]}" "${CURRENT_SER_STATUS}"
	echo "[${blue}?${reset}] Please enter your option:(a: choose another services or q: quit)"
	echo "[0] Start service [1] Stop service [2] Restart service [3] Do nothing [q] Quit"
	read OPTION

	

	case "${OPTION}" in

		"0")
			clear
			echo "Starting ${SERVICES_NAME[$SERVICE_KEY]}..."
			sudo systemctl start ${SERVICES[$SERVICE_KEY]}
			echo "[${green}✓${reset}] Completed!"
			echo
			;;

		"1")
			clear
			echo "Stopping ${SERVICES_NAME[$SERVICE_KEY]}..."
			sudo systemctl stop ${SERVICES[$SERVICE_KEY]}
			echo "[${green}✓${reset}] Completed!"
			echo
			;;

		"2")
			echo "Restarting ${SERVICES_NAME[$SERVICE_KEY]}..."
			;;
		"3")
			clear
			continue
			;;
		"q")
			exit_program
			;;
		*)
			invalid_key_error
			;;
	esac
done



