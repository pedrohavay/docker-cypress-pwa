echo -e "\nExecuting tasks...\n"

npm run cypress cypressReport
CURRENT_DATE=$(date --iso-8601)
mkdir cypress/reporter/$CURRENT_DATE/
rsync -a cypress/reporter/ cypress/reporter/$CURRENT_DATE/ --exclude $CURRENT_DATE
find cypress/reporter -mindepth 1 ! -regex "cypress/reporter/$CURRENT_DATE\(/.*\)?" -delete
