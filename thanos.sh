#!/bin/bash

num_remain=0
num_dust=0

snap_dir () {
    shopt -s nullglob dotglob

    for soul in "$1"/*; do
        if [ -d "$soul" ]; then
            snap_dir "$soul"
        else 
             JUDGEMENT=`echo -n "$soul" | gzip -1 -c | tail -c8 | hexdump -n4 -e '"%u"'`
             #echo "$soul $JUDGEMENT" 
             if [ "$JUDGEMENT" -gt 2147483647 ] # (2^32-1) / 2
                 then
                     echo "$soul REMAINS"
                     num_remain=$((num_remain + 1))
                     #echo $num_remain
                 else
                     rm -f "$soul"
                     echo "$soul IS DUST"
                     num_dust=$((num_dust + 1))
                     #echo $num_dust
             fi
        fi
    done
}

if [ $# -eq 0 ]; then
    >&2 echo "You must provide a target to snap."
    exit 1
fi

read -r -p "Are you sure you want to snap: $1? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -n "You should have gone"
    sleep 0.5
    echo -n "."
    sleep 0.5
    echo -n "."
    sleep 0.5
    echo -n "."
    sleep 1
    echo " FOR THE HEAD!!!"
    sleep 1
    
    snap_dir "$1"

    echo "$num_remain SOULS REMAIN"
    echo "$num_dust SOULS ARE DUST"

else
    echo "Reality is often disappointing..."
fi
