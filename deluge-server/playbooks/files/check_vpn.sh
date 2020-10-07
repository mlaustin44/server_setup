#!/bin/bash
MYIP=$(curl https://ipinfo.io/ip)
MYLOC=$(curl https://ipvigilante.com/$MYIP)
LOCERR=$?
MYCITY=$(echo $MYLOC | jq '.data.city_name')
MYISP=$(curl -s https://www.w111hoismyisp.org | grep -oP -m1 '(?<=isp">).*(?=</p)')
ISPERR=$?

ispdown=false

if [ "$MYCITY" = "null" ] || [ $MYCITY = "Waukesha" ] || [ "$MYISP" = "AT&T Corp." ] || [ $LOCERR -ne 0 ] || [ $ISPERR -ne 0 ]; then 
    printf "VPN connection down at time $(date)\n\tCity: $MYCITY\n\tCity Error Code: $LOCERR\n\tISP: $MYISP\n\tISP Error Code: $ISPERR" >> /home/$USER/vpnlog
    ispdown=true
fi

if [ "$ISPDOWN" = "true" ]; then 
    echo test
fi