#!/bin/bash

pdbfile=$1
convertTo=$2
convertTo=${convertTo,,}

# Correcting typos and modifying some sed and awk commands for functionality
if [[ "$convertTo" =~ "charmm" ]]
then
    sed -i 's:\ DA:ADE:g; s:\ DC:CYT:g; s:\ DG:GUA:g; s:\ \ U:URA:g; s:\ DT:THY:g' "$pdbfile"
    sed -i 's:C7\ \ \ DT:C5M\ THY:g' "$pdbfile"
    sed -i 's:OP1:O1P:g; s:OP2:O2P:g' "$pdbfile"
    sed -i '/C7\ \ THY\ A\ \ \ 7/d' "$pdbfile"  # Fixed variable name typo
    echo "REMARK" > "a_$pdbfile"
    echo "REMARK" > "b_$pdbfile"
    awk -v a="a_$pdbfile" -v b="b_$pdbfile" '{  # Corrected variable assignment in awk
        if ($6 == 7)
            gsub($4,"URA")
        if ($5 == "A")
            print $0 >> a
        else
            print $0 >> b
        }' "$pdbfile"
    echo "END" >> "a_$pdbfile"
    echo "END" >> "b_$pdbfile"
elif [[ "$convertTo" =~ "amber" ]]
then
    sed -i 's:ADE:\ DA:g; s:CYT:\ DC:g; s:GUA:\ DG:g; s:URA:\ \ U:g; s:THY:\ DT:g' "$pdbfile"
    sed -i 's:C5M\ THY:C7\ \ \ DT:g' "$pdbfile"
    sed -i 's:O1P:OP1:g; s:O2P:OP2:g' "$pdbfile"
    sed -i '/C7\ \ \ DT\ A\ \ \ 7/d' "$pdbfile"  # Fixed a sed command syntax error
    echo "REMARK" > "a_$pdbfile"
    echo "REMARK" > "b_$pdbfile"
    awk -v a="a_$pdbfile" -v b="b_$pdbfile" '{  # Corrected variable assignment in awk
        if ($6 == 7)
            gsub($4," U")
        if ($5 == "A")
            print $0 >> a
        else
            print $0 >> b
        }' "$pdbfile"
    echo "END" >> "a_$pdbfile"
    echo "END" >> "b_$pdbfile"
else
    echo "Error: second argument must be given either as \"charmm\" or \"amber\""
fi
#awk 'BEGIN{rold="";iat=0;ires=0;};\
#  {if($1=="ATOM"){\
#     iat++;r=substr($0,24,4);if(r!=rold){ires++;rold=r;};\
#     printf("%s%5d%s%4d%s\n",substr($0,1,6),iat,substr($0,12,11),ires,substr($0,27));}\
#   else print;}' "b_$pdfile.pdb"
