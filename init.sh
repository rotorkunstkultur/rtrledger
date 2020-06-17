
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

# check for tools needed by the package
echo -e "${BOLD}Toolscheck${NC}"
tools=('hledger' 'awk' 'sed')

for i in ${tools[@]}
do
    command -v $i >/dev/null && echo -e "\t$i is ${GREEN}THERE${NC}" || { echo -e "\t$i ${RED}NOT INSTALLED${NC}\n Call ${BOLD}./init.sh${NC} when available.\n  Aborting."; exit 1; }
done

echo -n "Creating folder structure "
# todo more detailed check if existing, etc
mkdir lib lib/documents lib/assets lib/tools lib/journals lib/journals/$(date +%Y) >/dev/null 2>&1 && echo -e "\t${GREEN}DONE${NC}" || echo -e "\n\t${RED}FAILURE:${NC} They might already exist ;)"

dialog --clear --backtitle "Backtitle here" --title "Title here" --menu "Choose one of the following options:" 15 40 4 \
1 "Option 1" \
2 "Option 2" \
3 "Option 3"

PS3='Do you want to set the current ledger as an .bashrc env?: '
foods=("NO" "YES" "QUIT")
select fav in "${foods[@]}"; do
    case $fav in
        "NO")
            echo "You're gonna have to call: hledger -i $(pwd)/ledger.journal"
            exit
            ;;
        "YES")
            echo "export LEDGER_FILE=$(pwd)/ledger.journal" >> ~/.bashrc
            echo ".env set - you should now be able to call hledger from anywhere to get your ledger"
            exit
            ;;
       "QUIT")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done

# todo get tabula-java
#curl -s https://api.github.com/repos/tabulapdf/tabula-java/releases/latest \
#| jq '.assets.browser_download_url'