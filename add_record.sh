# $1 = oldfilePath
# $2 = country name
# $3 = country code
# $4 = year
# $5 = value
# $6 = newfilePath
{ echo "${2},${3},${4},${5}"; cat $1; } > $6

