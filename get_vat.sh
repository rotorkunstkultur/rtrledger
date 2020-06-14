RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

timesspans=('jan-mar' 'apr-jun' 'jul-sep' 'oct-dec')

#10.04.2020	10.05.2020
#2. Quartal 2020	10.07.2020	10.08.2020
#3. Quartal 2020	10.10.2020	10.11.2020
#4. Quartal 2020	10.01.2021

#echo "Q1-2020"

for i in ${timesspans[@]}
do
    vorsteuer[19]=$(hledger reg 3806 amt:\>0 -p $i | tail -1 | grep -E -o "[0-9]+?,[0-9]{2}€$" | tr -d '€\n'  | sed 's/,/./g')
    vorsteuer[7]=$(hledger reg 3801 amt:\>0 -p $i | tail -1 | grep -E -o "[0-9]+?,[0-9]{2}€$" | tr -d '€\n' | sed 's/,/./g')
    ust[19]=$(hledger reg 3806 amt:\<0 -p $i | tail -1 | grep -E -o "[0-9]+?,[0-9]{2}€$" | tr -d '€\n' | sed 's/,/./g')
    ust[7]=$(hledger reg 3801 amt:\<0 -p $i | tail -1 | grep -E -o "[0-9]+?,[0-9]{2}€$" | tr -d '€\n' | sed 's/,/./g')


    echo -e "${BOLD}$i:${NC}"
    echo -n -e "\t${BOLD}Vorsteuer:${NC}"
    echo -n -e "\t19%: ${GREEN}${vorsteuer[19]}€ ${NC}"
    echo -e "\t7%: ${GREEN}${vorsteuer[7]}€ ${NC}"
    echo -n -e "\tSumme: ${GREEN}"
    bc <<< "${vorsteuer[19]} + ${vorsteuer[7]}" | tr -d '\n'
    echo -e "€${NC}"

    echo -n -e "\t${BOLD}Umsatzsteuer:${NC}"
    echo -n -e "\t19%: ${GREEN}${ust[19]}€ ${NC}"
    echo -e "\t7%: ${GREEN}$ust07 ${NC}\n"

done