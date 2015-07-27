#!/bin/bash

VERSION=.07

system=$(uname -s)

defaultcss='
<style>
TABLE { border-collapse: collapse; border-spacing: 0px; }
TD.linenum { color: #909090; 
   text-align: right;
   vertical-align: top;
   font-weight: bold;
   border-right: 1px solid black;
   border-left: 1px solid black; }
TD.added { background-color: #DDDDFF; }
TD.modified { background-color: #BBFFBB; }
TD.removed { background-color: #FFCCCC; }
TD.normal { background-color: #FFFFE1; }
</style>
'

function usage () {
   cat <<EOS
${0} - Formats diff(1) output to an HTML page on stdout
http://kirk.webfinish.com/diff2html

Usage: ${0} [--help] [--copyleft] [--debug] [--no-style] [--no-header] [--only-changes] [--style-sheet file.css] [diff options] file1 file2

--help                 This message
--only-changes         Do not display lines that have no differences
--style-sheet file.css Use an alternative style sheet URL
--no-style             Suppress the inclusion of a style sheet
--no-header            Suppress the HTML,HEAD and BODY tags
--debug                Way too much output for you
--copyleft             Show the GNU v3 license
--version              Show the version number and exit
diff options           All other parameters are passed to diff

Examples:
diff2html file1.txt file2.txt > differences.html

Treat all files as text and compare  them  line-by-line, even if they do 
not seem to be text.
diff2html -a file1 file2 > differences.html

The same, but use the alternate style sheet contained in diff_style.css
diff2html --style-sheet diff_style.css -a file1 file2 > differences.html

Pipe stdout of diff to stdin of $0 (slightly faster)
diff file1 file2 | $0 [options] file1 file2

The default, hard-coded style sheet is the following: ${defaultcss}
Note 1: if you give invalid additionnal options to diff(1), diff2html will
        silently ignore this, but the resulting HTML page will be incorrect;

bash version of diff2html is released under the GNU v3+ GPL.
Feel free to submit bugs or ideas to <kirk@webfinish.com>.
EOS
}

function inarray_changed() {
START=0
let STOP=${#changed[@]}-1
TEST=$1
while [ $START -lt $STOP ]
do
	
	N=$(( ($START + $STOP)/2 ))
    
    [[ $TEST -gt ${changed[${N}]} ]] && {
        let START=$N+1
    	N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -lt ${changed[${N}]} ]] && {
        let STOP=$N-1
	    N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -eq ${changed[${N}]} ]] && {
        echo "$N"
        return $N
        break
    }    
done

#not in the zero based array
echo "-1"
return -1

}

function inarray_added() {
START=0
let STOP=${#added[@]}-1
TEST=$1
while [ $START -lt $STOP ]
do
	
	N=$(( ($START + $STOP)/2 ))
    
    [[ $TEST -gt ${added[${N}]} ]] && {
        let START=$N+1
	    N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -lt ${added[${N}]} ]] && {
        let STOP=$N-1
	    N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -eq ${added[${N}]} ]] && {
        echo "$N"
        return $N
        break
    }

done

#not in the zero based array
echo "-1"
return -1

}


function inarray_deleted() {
START=0
let STOP=${#deleted[@]}-1
TEST=$1
while [ $START -lt $STOP ]
do
	
	N=$(( ($START + $STOP)/2 ))
    
    [[ $TEST -gt ${deleted[${N}]} ]] && {
        let START=$N+1
    	N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -lt ${deleted[${N}]} ]] && {
        let STOP=$N-1
    	N=$(( ($START + $STOP)/2 ))
    }
    [[ $TEST -eq ${deleted[${N}]} ]] && {
        echo "$N"
        return $N
        break
    }    
done

echo "-1"
return -1

}

function instr () {
    
    for (( strpos=0 ; strpos < ${#1} ; strpos ++ ))
    do
        [[ "${1:${strpos}:${#2}}" == "${2}" ]] && break
    done

    [[ "$strpos" -eq "${#1}" ]] && strpos=-1
    
    echo $strpos
    return $strpos
}    

function str2htm () {
#Get the return value of this function 
# by exec: html=$(str2htm "$MYSTR")

    # Replace ampersand with html code
    s1="${1//&/&amp;}"
    if [ ${#s1} -eq 0 ]
    then
        return 0
    fi
    # Replace < and > with html codes
    s1="${s1//</&lt;}"
    s1="${s1//>/&gt;}"
    # Replace double spaces with nbsp
    #  Improves visual formatting
    s1=${s1//  /&nbsp;&nbsp;}
    # Replace spaces at beginning of line with nbsp
    #  Prevents some browsers from reducing leading spaces
    s1=${s1/# /&nbsp;}
    # Results to stdout
    echo -e "${s1}"
}

onlychanges='false'
diffopts=''
header='true'
debug='false'

#process command line switches
while [ $# -gt 0 ]
do
    case "${1}" in
    "--help")
        usage
        exit
        ;;
    "--only-changes")
        onlychanges="true"
        ;;
    "--style-sheet")
        shift
        defaultcss="<link rel=\"stylesheet\" href=\"${1}\" type=\"text/css\">"
        ;;
    "--no-style")
        defaultcss=""
        ;;
    "--no-header")
        header="false"
        ;;
    "--debug")
        debug="true"
        ;;
    "--copyleft")
        # Show 'em our @55
        tail -n 620 $0 | sed 's/^# //'
        exit
        ;;
    "--version")
        echo $VERSION
        exit
        ;;
    *)
        [[ -f "${1}" ]] || diffopts="${diffopts} ${1}"
        [[ -f "${1}" ]] && {
            #We have our first file parameter
            file1="${1}"
            #Get the comparison file
            shift
            [[ -e "${1}" ]] || {            
                usage
                exit 1
            }
            file2="${1}"
        }
        ;;
    esac
    shift
done

if [ ${#file1} -eq 0 ] || [ ${#file2} -eq 0 ]
then
    echo "No input files given"
    usage
    exit 1
fi

#find out if we got the diff input via stdin
while read -t 1 diffline
do
    diff="${diff}\n${diffline}"
done

if [ ${#diff} -eq 0 ]
then
  #no diff stdin
  #call it on the command line
  diff=`diff ${diffoptions} "${file1}" "${file2}"`
fi

#Thow away the output lines from diff
# < blah1
# ---
# > blah2
#All we care about are numeric indicators
# 3,4c4,7 
diff=`echo -e "${diff}" | sed -e '/^[^[:digit:]]/d'`

declare -a difflines

#Expand what's left into an array
IFS=$'\n'
difflines=(${diff})
difflimit=${#difflines[@]}

#declare some buffer arrays
declare -a changed
declare -a deleted
declare -a added

if [ "${debug}" == "true" ]
then
    echo -e "Diff Count: $difflimit"
    echo -e "<br>Diffs:"
    diffcounter=0
    for (( diffcounter=0 ; diffcounter<=$difflimit ; diffcounter++ ))
    do
      echo -e "<br>${difflines[$diffcounter]}"
    done  
fi

#Create a counter to adjust
# line labels after deleted lines
let delete_offset=0

#Read the differences into the buffer arrays
for (( diffcounter=0 ; diffcounter<${difflimit} ; diffcounter++ ))
do    
    diffline="${difflines[${diffcounter}]}"

    # all valid diff lines match the expression:
    #  [[:digit:]]*,+[[:digit]]+[[:alpha:]][[:digit:]]*,+[[:digit:]]+
    # "case" does some simple file glob style pattern matching, not full regex
    #  it's enough for these 4 cases.
    match="${diffline//[^[:alpha:]]/}"
    case "${diffline}" in
        *,*,*)
           # w,xAy,z
           regex=\([[:digit:]]*\),\([[:digit:]]*\)[[:alpha:]]\([[:digit:]]*\),\([[:digit:]]*\)
           [[ "${diffline}" =~ ${regex} ]] && {
                f1_start=${BASH_REMATCH[1]}
                f1_end=${BASH_REMATCH[2]}
                f2_start=${BASH_REMATCH[3]}
                f2_end=${BASH_REMATCH[4]}
                }
           ;;
        *[acd]*,*)
           # wAy,z
           regex=\([[:digit:]]*\)[[:alpha:]]\([[:digit:]]*\),\([[:digit:]]*\)
           [[ "${diffline}" =~ ${regex} ]] && {
                f1_start=${BASH_REMATCH[1]}
                f1_end=${BASH_REMATCH[1]}
                f2_start=${BASH_REMATCH[2]}
                f2_end=${BASH_REMATCH[3]}
                }
           ;;
        *,*[acd]*)
           # w,xAy
           regex=\([[:digit:]]*\),\([[:digit:]]*\)[[:alpha:]]\([[:digit:]]*\)
           [[ "${diffline}" =~ ${regex} ]] && {
                f1_start=${BASH_REMATCH[1]}
                f1_end=${BASH_REMATCH[2]}
                f2_start=${BASH_REMATCH[3]}
                f2_end=${BASH_REMATCH[3]}
                }
           ;;
        *)
           # wAy
           regex=\([[:digit:]]*\)[[:alpha:]]\([[:digit:]]*\)
           [[ "${diffline}" =~ ${regex} ]] && {
                f1_start=${BASH_REMATCH[1]}
                f1_end=${BASH_REMATCH[1]}
                f2_start=${BASH_REMATCH[2]}
                f2_end=${BASH_REMATCH[2]}
                }
           ;;
    esac

    # How many changes?
    let f1_lc=(${f1_end}-${f1_start})+1
    let f2_lc=(${f2_end}-${f2_start})+1
    
    [[ "$debug" == "true" ]] && {
        echo "<pre>"
        echo "match:    $match"
        echo "diffline: $diffline"
        echo "f1_start: $f1_start"
        echo "f1_end:   $f1_end"
        echo "f2_start: $f2_start"
        echo "f2_end:   $f2_end"
        echo "f1_lc:    $f1_lc"
        echo "f2_lc:    $f2_lc"
        echo "</pre>"
    }

    case $match in
    "c")
        if [[ $f2_lc -lt $f1_lc ]]
        then
            #lines merged, missing lines are "deleted"
            for (( counter=$f1_start ; counter<${f1_start}+${f2_lc} ; counter++ ))
            do
                let dummy=$counter-$delete_offset
                changed[${#changed[@]}]=$dummy
            done

            for (( counter=$f1_start+$f2_lc ; counter<$f1_end+1 ; counter++ ))
            do
                let dummy=$counter-$delete_offset
                deleted[${#deleted[@]}]=$dummy
            done

        elif [[ $f1_lc -lt $f2_lc ]]
        then
            #Lines are split, extra lines are "added"
            for (( counter=$f1_start ; counter<$f1_end+1 ; counter++ )) 
            do
                let dummy=$counter-$delete_offset
                changed[${#changed[@]}]=$dummy
            done

            for (( counter=$f2_start+${f1_lc} ; counter<$f2_end+1 ; counter++ ))
            do
                let dummy=$counter-$delete_offset
                added[${#added[@]}]=$dummy
            done
        else
            for (( counter=$f1_start ; counter<$f1_end+1 ; counter++ ))
            do
                let dummy=$counter-$delete_offset
                changed[${#changed[@]}]=$dummy
            done
        fi
        ;;
    "a")
        for (( counter=$f2_start ; counter<$f2_end+1 ; counter++))
        do
            let dummy=$counter-$delete_offset
            added[${#added[@]}]=$dummy
        done
        ;;
    *)
        for (( counter=$f1_start ; counter<=$f1_end ; counter++ ))
        do
            #(( delete_offset++ ))
            let dummy=$counter-$delete_offset
            deleted[${#deleted[@]}]=$dummy
        done
        ;;
    esac

done 

declare -a file1_lines
declare -a file2_lines

#Read the files into array variables
#  Hmmm, seems to have a small glob size limit
#    Hmmm, Hmmm. Doesn't work in a sub shell
#     where the parent is using redirection anyway
#IFS=$'\n'
#file1_lines=($(< "${file1}"))
#IFS=$'\n'
#file2_lines=($(< "${file2}"))
#IFS=$'$OLDIFS'

#Do it the hard way
#  Redirection is bad here
#   need to find another way
exec 3<>"${file1}"
IFS=$'\n'
while read f1_line
#for f1_line in $(cat ${file1})
do
    file1_lines[${#file1_lines[@]}]="${f1_line}"
done <&3 # < $file1
exec 3>&-

exec 3<>"${file2}"
while read f2_line
#for f2_line in $(cat ${file2})
do
    file2_lines[${#file2_lines[@]}]="${f2_line}"
done <&3 #< $file2
exec 3>&-

changed_lnks="None "
[[ ${#changed[@]} -gt 0 ]] && {
    #Links to named references in HTML
    changed_lnks=""
    for (( counter=0 ; counter<${#changed[@]} ; counter++ ))
    do
        link="${changed[${counter}]}"
        changed_lnks[${#changed_lnks[@]}]="<a href='#${file1}_${link}'>${link}</a>&nbsp; "
    done
}

added_lnks="None "
[[ ${#added[@]} -gt 0 ]] && {
    added_lnks=""
    #Links to named references in HTML
    for (( counter=0 ; counter<${#added[@]} ; counter++ ))
    do
        link=${added[${counter}]}
        added_lnks[${#added_lnks[@]}]="<a href='#${file2}_${link}'>${link}</a>&nbsp; "
    done
}

deleted_lnks="None "
[[ ${#deleted[@]} -gt 0 ]] && {
    deleted_lnks=""
    #Links to named references in HTML
    for (( counter=0 ; counter<${#deleted[@]} ; counter++ ))
    do
        link=${deleted[${counter}]}
        deleted_lnks[${#deleted_lnks[@]}]="<a href='#${file1}_${link}'>${link}</a>&nbsp; "
    done
}

# Printing the HTML header, and various known information
[[ "$header" == "true" ]] && {
    cat <<EOS
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
 "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head>
    <title>Differences between $file1 and $file2</title>
    $defaultcss
</head>
<body>
EOS
}

# Finding the mdate of a file in various *nix platforms
case "$system" in 
  "Darwin")
      file1_mdate=$(stat -f%-Sc -t "%Y-%m-%d %H:%M:%S" "${file1}")
      file2_mdate=$(stat -f%-Sc -t "%Y-%m-%d %H:%M:%S" "${file2}")
      ;;
  "Linux")
      file1_mdate=$(date -r "${file1}" "+%Y-%m-%d %H:%M:%S")
      file2_mdate=$(date -r "${file2}" "+%Y-%m-%d %H:%M:%S")
      ;;
  *)                    # Cygwin/HP/Unix/yadayada
      #take a stab at it with GNU ls
      file1_mdate=$(ls -l --time-style="+%Y-%m-%d %H:%M:%S" "${file1}" | 
            sed 's/.*\([[:digit:]]\{4\}-[[:digit:]]*-[[:digit:]]* [[:digit:]]*:[[:digit:]]*:[[:digit:]]*\).*/\1/')
      file2_mdate=$(ls -l --time-style="+%Y-%m-%d %H:%M:%S" "${file2}" | 
            sed 's/.*\([[:digit:]]\{4\}-[[:digit:]]*-[[:digit:]]* [[:digit:]]*:[[:digit:]]*:[[:digit:]]*\).*/\1/')
      ;;
esac

cat <<EOS
<table>
<tr><td width="70%">
<table>
    <tr>
        <td class="modified">Modified line(s):&nbsp;</td>
        <td class="modified">`printf '%s' "${changed_lnks[@]}"`</td>
    </tr>
    <tr>
        <td class="added">Added line(s):&nbsp;</td>
        <td class="added">`printf '%s' "${added_lnks[@]}"`</td>
    </tr>
    <tr>
        <td class="removed">Removed line(s):&nbsp;</td>
        <td class="removed">`printf '%s' "${deleted_lnks[@]}"`</td>
    </tr>
</table>
</td>
<td width="30%">
<font size="-2"><i>Generated by <a href="http://kirk.webfinish.com"><b>diff2html</b></a><br>
&copy; 2009 Kirk Roybal, WebFinish<br>
Python version by: Yves Bailly, MandrakeSoft S.A. 2001<br>
<b>diff2html</b> is licensed under the <a href="http://www.gnu.org/copyleft/gpl.html">GNU GPL</a>.</i></font>
</td></tr>
</table>
<hr/>
<table>
    <tr>
        <th>&nbsp;</th>
        <th width="45%"><strong><big>${file1}</big></strong></th>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <th width="45%"><strong><big>${file2}</big></strong></th>
    </tr>
    <tr>
        <td width="16">&nbsp;</td>
        <td>
        ${#file1_lines[@]} lines<br/>
        $(cat "${file1}" | wc -c) bytes<br/>
        Last modified : ${file1_mdate} <br>
        <hr/>
        </td>
        <td width="16">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td>
        ${#file2_lines[@]} lines<br/>
        $(cat "${file2}" | wc -c) bytes<br/>
        Last modified : ${file2_mdate} <br>
        <hr/>
        </td>
    </tr> 
EOS

# Running through the differences...
fl1=0
fl2=0
[[ "$debug" == "true" ]] && {
    echo "\${file1_lines[]} = ${#file1_lines[@]}"
    echo "\${file2_lines[]} = ${#file2_lines[@]}"
}

#process until we reach the end of both comparison files
until [[ "$fl1" -ge "${#file1_lines[@]}" && "$fl2" -ge "${#file2_lines[@]}" ]]
do
    let dummy=$fl2+1
    [[ `inarray_added $dummy` -gt -1 ]] && {
            # This is an added line
            line2=`str2htm "${file2_lines[${fl2}]}"`
            cat <<EOS
    <tr>
        <td class="linenum">&nbsp;</td>
        <td class="added">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td class="linenum"><a name="${file2}_${dummy}">${dummy}</a></td>
        <td class="added">${line2}</td>
    </tr>
EOS
            (( fl2++ ))
    # found a match, goto top of loop
            continue
        }

    let dummy=${fl1}+1
    [[ `inarray_deleted $dummy` -gt -1 ]] && {
            # This is a deleted line
            line1=$(str2htm "${file1_lines[${fl1}]}")
            cat <<EOS
    <tr>
        <td class="linenum"><a name="${file1}_${dummy}">${dummy}</a></td>
        <td class="removed">${line1}</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">&nbsp;</td>
        <td class="removed">&nbsp;</td>
    </tr>
EOS
            (( fl1++ ))
    # found a match, goto top of loop
             continue
        }


    let dummy=$fl1+1
    [[ `inarray_changed $dummy` -gt -1 ]] && {
            # This is a changed line
            line1=$(str2htm "${file1_lines[${fl1}]}")
            line2=$(str2htm "${file2_lines[${fl2}]}")
            # can't do math inside the heredoc
            let dummy1=${dummy}
            let dummy2=${fl2}+1
            cat <<EOS
     <tr>
        <td class="linenum"><a name="${file1}_${dummy1}">${dummy1}</a></td>
        <td class="modified">${line1}</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">${dummy2}</td>
        <td class="modified">${line2}</td>
    </tr>
EOS
            (( fl1++ ))
            (( fl2++ ))
    # found a match, goto top of loop
             continue
        }

    # These lines have nothing special
    [[ "$onlychanges" == "false" ]] && {
        let dummy1=${fl1}+1
        let dummy2=${fl2}+1
        line1=`str2htm "${file1_lines[${fl1}]}"`
        line2=`str2htm "${file2_lines[${fl2}]}"`
        cat <<EOS
    <tr>
        <td class="linenum">${dummy1}</td>
        <td class="normal">${line1}</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">${dummy2}</td>
        <td class="normal">${line2}</td>
    </tr>
EOS
    }
    (( fl1++ ))
    (( fl2++ ))

done

cat <<EOS  
</table>
<hr/>
<i>Generated by <b>diff2html</b> on $(date +"%Y-%m-%d %H:%M:%S")</i>
EOS

[[ "$header" == "true" ]] && {
    cat <<EOS
    </body>
    </html>
EOS
}

#Successful end
exit

