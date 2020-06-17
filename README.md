# rtrLEDGER

A hledger system for chaotic German freelancers based on the [SKR04](https://www.datev.de/web/de/datev-shop/material/skr-04-englisch/) chart of accounts by DATEV bearing in mind the [GoBD](https://billwerk.io/subscription_economy/gobd-overview-and-practical-guidelines-of-the-german-directive/) (German directive for orderly bookeeping)

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)


## General Info

I am still a beginner and always glad to learn and improve code! So if you see something that could be done more elegant or faster do not hesitate to ;)

If you want to help me in improving the deployment process so that others can really use this thing (havent tested it, yet) - all welcome

#### Basic folder structure
    
    ./init.sh

Sets up the initial folder structure:

    lib/
    lib/documents #
    lib/tools # for tools sub
    lib/journals/$(date +%Y) # current year
    lib/assets # for depreciation journals

[TODO] 

##### ledger.journal

Collects all the journal files in the above file structure and delivers an alias based chart of account, up to this day incomplete [SKR04](https://www.datev.de/web/de/datev-shop/material/skr-04-englisch/). This file should normally be untouched and is the working book. Due to the wildcard-setup everybody can choose his or her own workflow.
[TODO] Full SKR04 chart of accounts

##### Bank CSV - hledger

    ./update_csv.sh

works with:

    lib/documents/%bankname/%year/*.csv
    lib/documents/%bankname/%bankname.rules.csv [mandatory]
    

* Look through all documents/*-folders
* check csv for utf8, check if .utf8.csv exists, otherwise iconv-convert it and create it
* run through folders check for \$bankname.csv.rules and run subdirs ($year)
* \$bankname can also be your sent|received invoices workdir
* [TODO] update if rules-file has been changed since last update of the *.journal-files
* [TODO] ask if script should Update/Update All/Ignore existing files

#### VAT Management 

    ./get_vat.sh

* Get numbers for german periodic vat declaration for each quarter based on SKR04-Accounts
* [TODO]: Different timespans

#### Depreciation
    ./update_depreciation.sh
* Depreciation is set by posting a good to 0440 Machines account and setting a eg. depreciate:7years
* Its straight depreciation only atm
Workflow:
* Scan for depreciate: tags and allow depreciate:xyears or depreciate:ymonths
* use start the month AFTER buying
* write lib/assets/$comment.journal from day 1 monthly till timespan+day1 
* [TODO]: Beautify code, offer options, create German "Sammelabschreibung/Poolabschreibung" (Group depreciation?) for goods priced between 250-1000€

#### Invoicing
* [TODO]
* A latex based invoice template that takes data from csv

#### Zugferd / PDF Invoice Management
* [TODO]
* Automatic processing of received invoices
* Check for depreciation limits and assist in handling those
* Remember choices for positions, allow comments, tags

#### Finalize: Currency Conversion / Doubles 
* [TODO]
* Automatic processing of currency conversion eg. Paypal/Credit Card based on comments
* Find and do some method to check and finalize monthly bookings by committing to git, hash  - chance to create some gobd-save solution?

## Technologies

Written mostly in beginners copy&paste shell plus incorporating existing tools in eg. python

* [hledger](hledger.org) -- great & intuitive plaintextaccounting based on [ledger](https://www.ledger-cli.org/)
* [depreciateforledger](https://github.com/tazzben/DepreciateForLedger/) -- Python script that allows for various depreciation methods and is slightly adjusted
* [tabular-java](https://github.com/tabulapdf/tabula-java) -- for pdf processing, lib/tools/tabula*.jar
* [sed](https://linux.die.net/man/1/sed), [iconv](https://linux.die.net/man/1/iconv), [awk](https://linux.die.net/man/1/awk), [gawk](https://www.gnu.org/software/gawk/manual/)

## Setup

* Check above Technologies in your package management system or do manually
* Git clone this repo
* ./init.sh creates local folder structure, set ledger-env if you want, TODO: creates example bank submodule
* setup banks with creating lib/documents/\$bankname/$bankname.rules.csv with [hledger csv format](https://hledger.org/csv.html) and set banks-csvs to lib/documents/\$bankname/$year/*.csv
* run ./update_csv.sh - checks for utf8, converts if necessary takes the parent *.csv.rules to write according journals
* look through your ledger using hledger-ui and check for adjustments that need to be made in your rules-file - re-run update.csv
* use the lib/journals/$year folder to write additional postings. 

