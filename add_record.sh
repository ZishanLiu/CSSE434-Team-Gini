# $1 = oldfilePath
# $2 = country name
# $3 = country code
# $4 = year
# $5 = value
# $6 = newfilePath
# echo "{0},{1},{2},{3}" -f $2,$3,$4,$5 | add-content -path $1
{ echo "${2},${3},${4},${5}"; cat $1; } > $6

