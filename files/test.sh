
function TAR_NAME() {
    shopt -s nocasematch
    filepath=$1
    matchRegex='.*\.(tgz$)|(tar\.gz$)|(tar)'

    while read line
    do

        NAME=`echo $line | cut -d "," -f1`

        array=$(echo $line | tr "," "\n")
        for i in $array
        do
            if [ $i = *.tar ]; then
                export TARFILE=$i
            fi
           # [[ -f "$i" ]] &&  [[ "$i" =~ "$matchRegex"  ]] &&  echo "$i";
        done

    done < $filepath
    echo $TARFILE
    echo $REGDIR
}

export REGDIR="HELLO BAAL"
export myVAR=$(TAR_NAME VPAS.ISGHUB.SUBACCOUNT.txt)
echo "here " $myVAR
