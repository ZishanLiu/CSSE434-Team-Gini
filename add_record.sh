# $1 = filePath
# $2 = country name
# $3 = country code
# $4 = year
# $5 = value
echo "{0},{1},{2},{3}" -f $2,$3,$4,$5 | add-content -path $1
