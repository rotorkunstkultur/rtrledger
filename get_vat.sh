RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

echo "19% Input / Vereinnahmt:"
hledger reg 3806 amt:\<0 -p quarterly
echo ""
echo "7% Input / Vereinnahmt:"
hledger reg 3801 amt:\<0 -p quarterly
echo ""
echo "19% Output / Vorsteuer:"
hledger reg 3806 amt:\>0 -p quarterly
echo ""
echo "7% Output / Vorsteuer:"
hledger reg 3801 amt:\>0 -p quarterly
echo ""
