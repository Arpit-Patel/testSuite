#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Incorrect number of command line arguments" 1>&2
    exit 1
fi
while read line; do
        for file in ${line}; do
                if [ -f "${file}.in" ] && [ -f "${file}.out" ] && [ -f "${file}.args" ]; then
                        if (!(cmp -s <(cat ${file}.in | $2 $(cat ${file}.args)) <(cat ${file}.out))); then
                                echo Test failed: "${file}"
                                echo Input:
                                cat ${file}.in
                                echo Expected:
                                cat ${file}.out
                                echo Actual:
                                cat ${file}.in | $2 $(cat ${file}.args)
                        fi
		elif [ ! -f "${file}.args" ]; then
			if (!(cmp -s <(cat ${file}.in | $2) <(cat ${file}.out))); then
                                echo Test failed: "${file}"
                                echo Input:
                                cat ${file}.in
                                echo Expected:
                                cat ${file}.out
                                echo Actual:
                                cat ${file}.in | $2
                        fi
                elif [ ! -f "${file}.in" ]; then
                        echo 'missing or unreadable .in' 1>&2
                        exit 1
                elif [ ! -f "${file}.out" ]; then
                        echo 'missing or unreadable .out' 1>&2
                        exit 1
                else
                        echo 'missing or unreadable .in or .out files' 1>&2
                        exit 1
                fi
        done
done < <(cat $1)
