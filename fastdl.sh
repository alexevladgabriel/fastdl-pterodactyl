#!/bin/bash

HOME_URL="https://node.pterodactyl.io" 
API_KEY="YOUR_GENERATED_API_KEY"

PTERODACTYL="/var/lib/pterodactyl/volumes/"
FASTDL="/var/www/fastdl"

inotifywait -m -e create --format="%w%f" $PTERODACTYL | while read -r line 
do
    URL="$HOME_URL/api/application/servers/?filter[uuid]=${line##*/}"

    GAME=$(curl -s $URL \
                  -H "Authorization: Bearer $API_KEY" \
                  -H "Content-Type: application/json" \
                  -H "Accept: Application/vnd.pterodactyl.v1+json" \
                  | grep -oP '(?<=game )[^ ]*' | tail -1)

    if [ -z "$GAME" ] || [ "$GAME" == "{{SRCDS_GAME}}" ]; then
        GAME=$(curl -s $URL \
                -H "Authorization: Bearer $API_KEY" \
                -H "Content-Type: application/json" \
                -H "Accept: Application/vnd.pterodactyl.v1+json" \
                | grep -oP '"SRCDS_GAME":.*?[^\\]",' | perl -pe 's/"SRCDS_GAME"://; s/^"//; s/",$//')
    fi

    # echo "$(date +'%T') : [FASTDL] CURRENT GAME: $( [ -z $GAME ] && printf %s 'No game detected')" >> /var/log/pterodactyl/fastdl.log
    if [ ! -z "$GAME" ]; then
        echo "$(date +'%T') : [FASTDL] ${GAME} Detected" >> /var/log/pterodactyl/fastdl.log
        ln -s "$line/${GAME}/" "$FASTDL/${line##*/}"

        echo "$(date +'%T') : [FASTDL] Creating Symbolic Link: $FASTDL/${line##*/}" >> /var/log/pterodactyl/fastdl.log
        chmod 750 "$line"
    else
        echo "$(date +'%T') : [FASTDL] Not Detected/Supported - Contact Scai#8477" >> /var/log/pterodactyl/fastdl.log
    fi
done &

inotifywait -m -e delete --format="%w%f" $PTERODACTYL | while read -r line 
do
    if [ ! ${line##*/} == '%s' ]; then
        echo "$(date +'%T') : [FASTDL] Deleting Symbolic Link: $FASTDL/${line##*/}" >> /var/log/pterodactyl/fastdl.log
        rm -rf ${FASTDL}/${line##*/}
    fi
done &

wait
