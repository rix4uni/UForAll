#!/usr/bin/env bash

# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

banner(){
    echo -e "${BLUE}
\t\t __  __     ______   ______     ______     ______     __         __        
\t\t/\ \/\ \   /\  ___\ /\  __ \   /\  == \   /\  __ \   /\ \       /\ \       
\t\t\ \ \_\ \  \ \  __\ \ \ \/\ \  \ \  __<   \ \  __ \  \ \ \____  \ \ \____  
\t\t \ \_____\  \ \_\    \ \_____\  \ \_\ \_\  \ \_\ \_\  \ \_____\  \ \_____\ 
\t\t  \/_____/   \/_/     \/_____/   \/_/ /_/   \/_/\/_/   \/_____/   \/_____/ 
\t\t                    coded by ${YELLOW}@rix4uni${RED} in INDIA${RESET}"
}

showhelp(){
    banner
    echo -e "${GREEN}OPTIONS${RESET}"
    echo -e "   -d, --domain        Single Target domain (domain.com)"
    echo -e "   -l, --list          Multiple Target domain (interesting_subs.txt)"
    echo -e "   -t, --threads       number of threads to use (default 50)"
    echo -e "   -h, --help          Help - Show this help"
    echo -e "${GREEN}USAGE EXAMPLES${RESET}"
    echo -e "./uforall.sh -d domain.com -t 100"
    echo -e "./uforall.sh -l interesting_subs.txt -t 100"
    echo -e ""
}

# Run the domain through the various scripts and write the output to the specified file
SINGLE_DOMAIN(){
	echo "$domain" | python3 archive.py $threads | anew
	echo "$domain" | python3 otx.py $threads | anew
	echo "$domain" | python3 urlscan.py $threads | anew
	echo "$domain" | python3 commoncrawl.py $threads | anew
}

# Run the interesting subdomains through the scripts and append the output to the file
MULTIPLE_DOMAIN(){
	cat "$list" | python3 archive.py $threads | anew
	cat "$list" | python3 otx.py $threads | anew
	cat "$list" | python3 urlscan.py $threads | anew
	for url in $(cat "$list");do echo "$url" | python3 commoncrawl.py $threads | anew;done
}

while [ -n "$1" ]; do
    case $1 in
        -d|--domain)
            domain=$2
            SINGLE_DOMAIN
            exit 1 ;;

        -l|--list)
            list=$2
            MULTIPLE_DOMAIN
            exit 1 ;;

        -t|--threads)
            threads=$3
            exit 1 ;;

        -h|--help)
            showhelp
            exit 1 ;;
    esac
done