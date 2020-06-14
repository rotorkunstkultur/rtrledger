RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

# todo if set by argument
OVERWRITE=1

#iterate through folder
for dir in lib/documents/*/     # get all folders in documents
do
	
	# get working dir
	folder="${dir}"
	echo -e "\tCheck for: ${BOLD}$(basename "$folder")${NC}"
	
	# rules file naming convention
	rules="${dir}$(basename "$folder").csv.rules"

	if [[ -f $rules ]]
	then
		echo -e "\t\t${BOLD}$(basename "${rules}"):\t ${GREEN}EXISTS${NC}"
		echo -n -e "\t\t\t"

		#iterate through years in subfolder
		for yeardir in $dir*/
		do
			yeardir="${yeardir}"
			echo -n -e "$(basename $yeardir) "

			for csvfile in $yeardir*.csv $yeardir*.CSV
			do
				if [[ -f $csvfile ]]
				then
					
					#check if utf8 for encoding problems
					csvcharset=" $(file -bi "$csvfile"|awk -F "=" '{print $2}')  "
					
					#if no utf8 convert using iconv and overwrite csvfile, if file exists use utf8 url - not selected!
					if [ $csvcharset != "utf-8" ]
					then
						csvutf8="${csvfile%.*}.utf8.csv"						
						#if uf8 does not exist create
						if [[ ! -f $csvutf8 ]]; then
							iconv -f "$csvcharset" -t utf8 "$csvfile" -o $csvutf8
							echo -n -e "\n\t\t\t${GREEN}CONVERSION${NC} $(basename $csvfile) from ${BOLD}$csvcharset${NC}to UTF8"
							#overwrite filename
							csvfile=$csvutf8
						else
							#if file exists its already in the loop, skip
		
							continue
						fi
					fi

					#check if journal exists
					journalfile=${csvfile%.csv}.journal
					if [[ ! -f $journalfile ]]
					then
						hledger --rules-file=$rules -f=csv:$csvfile print -o $journalfile
						echo -e -n "\n \t\t\tJournal Missing: $(basename $journalfile)"
					else
						if [ $OVERWRITE = 0 ]
						then
							# user input ask to overwrite
							# todo adjust setting for N!
							echo -n -e "\n \t\t\tJournal availlable - Overwrite (y/n/A)?\n\t\t\t"
							
							# Read the option and store in a variable
						#	while getopts "an" option; do
							# Check the option value
					#		case ${option} in
					#		a ) #option a
					#			echo "Process is aborted"
					#		;;
					#		r ) #option r
					#			echo "Process is restarted"
					#		;;
					#		c ) #option c
					#			echo "Process is continuing"
					#		;;
					#		\? ) #invalid option
					#			echo "Use: [-a] or [-r] or [-c]"
					#		;;
					#		esac
					#		done
						else
							hledger --rules-file=$rules -f=csv:$csvfile print -o $journalfile
						fi
					fi
				fi
			done
			echo -e -n '\n\t\t\t'
		done
	else
		echo -e "\t\t${RED}NO RULES FILE FOUND${NC}\n\t\tFormat must be: ${BOLD}$(basename "$folder").csv.rules${NC}"
	fi
	echo -e "\n"	
done