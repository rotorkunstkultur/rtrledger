# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

# how to get all groups from comment
regexpcomment="depreciate:([[:digit:]]+)(.*)"

#for I in $(hledger print tag:depreciate 0440 amt:\>0 -O csv)
while read I
do
 # get accountname and check for assets account 0440
 dataAccount="$(echo $I | awk -F "\"*,\"*" '{print $8}')"
 if [[ $dataAccount  =~ '0440' ]]
 then
    # get Description for Depreciation
    dataName="$(echo $I | awk -F "\"*,\"*" '{print $6}')"
    # get filename_base
    dataFilename="$(echo $I | awk -F "\"*,\"*" '{print $2}' | sed 's/-//g')_$(echo $dataName | sed 's/ //g')"
    # get startDate
    dataDate="$(echo $I | awk -F "\"*,\"*" '{print $2}' | sed 's/-/\//g')"

    # get timesspan and split it into number & unit
    dataComment="$(echo $I | awk -F "\"*,\"*" '{print $7}')"
    if [[ $dataComment =~ $regexpcomment ]]
    then
        # I want monthly postings, allowed: years/months
        dataTime="${BASH_REMATCH[1]}"
        if [[ ${BASH_REMATCH[2]} == "years" ]]
        then
            dataTime=$(( $dataTime*12 ))
            dataTimeUnit="months"
        else
            dataTimeUnit="months"
        fi

        # get worth for beginning, solve problem with ###,###.## number format by using gawk, removing dots and replace the , with .
        dataValue="$(echo $I | gawk -vFPAT='"[^,]*|"[^"]*"' '{print $9}' | tr -d ".\"" | sed 's/,/./g')"
    
        echo -n "Gerät: $dataName"

        if [[ ! -f "lib/assets/$dataFilename.journal"  ]]
        then
            ./lib/tools/depreciateforledger/src/depreciate --cost="$dataValue" --residual=1 --method="straight" --periods="$dataTime" --periodtype="$dataTimeUnit"  -a "0 Anlagevermögen:Maschinen (0440)" -e "6 Betriebliche Aufwendungen:Abschreibungen auf Sachanlagen (ohne AfA auf Kfz und Gebäude) (6300)" --currency="€" --date="$dataDate" -n "$dataName" | sed '1,3d' > "lib/assets/$dataFilename.journal"
            echo -e "\t${GREEN}DONE${NC}"
        else 
            echo -e "\t${RED}EXISTS${NC}"
        fi

    else
        echo "$dataComment is not of format ##time"
        exit 1
    fi 
 fi
done < <(hledger print tag:depreciate 0440 amt:\>0 -O csv)

#while read -r line; do command "$line"; done

#cat deptest.txt | awk -F "\"*,\"*" '{print $3}' deptest.txt 

#depreciate --cost="1000.33" --residual=5.22 --method="sum" --periods=9 -a "Assets:Desks" -o "Liabilities:Credit Card" -n "Purchase of New Desk" --save "~/desktop/depreciate.txt"


#--save "~/desktop/depreciate.txt" 
#
