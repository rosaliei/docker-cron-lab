#!/bin/sh

cron_pattern="^(?#minute)(\*|(?:[0-9]|(?:[1-5][0-9]))(?:(?:\-[0-9]|\-(?:[1-5][0-9]))?|(?:\,(?:[0-9]|(?:[1-5][0-9])))*)) (?#hour)(\*|(?:[0-9]|1[0-9]|2[0-3])(?:(?:\-(?:[0-9]|1[0-9]|2[0-3]))?|(?:\,(?:[0-9]|1[0-9]|2[0-3]))*))(?#day_of_month)(\*|(?:[1-9]|(?:[12][0-9])|3[01])(?:(?:\-(?:[1-9]|(?:[12][0-9])|3[01]))?|(?:\,(?:[1-9]|(?:[12][0-9])|3[01]))*)) (?#month)(\*|(?:[1-9]|1[012]|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(?:(?:\-(?:[1-9]|1[012]|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))?|(?:\,(?:[1-9]|1[012]|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))*)) (?#day_of_week)(\*|(?:[0-6]|SUN|MON|TUE|WED|THU|FRI|SAT)(?:(?:\-(?:[0-6]|SUN|MON|TUE|WED|THU|FRI|SAT))?|(?:\,(?:[0-6]|SUN|MON|TUE|WED|THU|FRI|SAT))*))$"

cron_entry_added=0

if [[ -z ${CRON_TIME} ]];  
then
	echo "Env Var 'CRON TIME' NOT set. Not adding cron entry for Agent MAP"
else
	MATCHES=`echo "${CRON_TIME}" | grep -iE $cron_pattern | wc -l`
	if [[ $MATCHES -eq 0 ]];  
	then
		echo "Env Var 'Cron Time For MAP' set and is valid. Adding cron entry for MAP"

		entry_exchange="${CRON_TIME} sh /usr/share/nginx/html/scripts.sh"

		echo "${entry_exchange}" >> ./map_crontab

		cron_entry_added=1
		
	else
		echo "Env Var 'Cron Time For MAP' set but is INVALID. WONT add cron entry"
	fi
fi

if [ "$cron_entry_added" -eq "1" ];
then
	supercronic ./map_crontab &

	echo -e "Cron Entries added:\n$entry_exchange\n$entry_status_check"
fi