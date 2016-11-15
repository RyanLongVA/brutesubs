#/bin/bash

while [[ ! -f $gobusterfile || ! -f $enumallfile || ! -f $sublist3rfile ]] ;
do
	echo "All tools haven't finished running yet so waiting.."
	sleep 30
done

if [ -f $gobusterfile ] && [ -f $enumallfile ] && [ -f $sublist3rfile ];
	then 
		echo "All tools have finished running."
		echo "Now, combining all output to produce the final bruteforced subdomains list"
		sort -u /data/output/* > $temp1
		tr '[:upper:]' '[:lower:]' < $temp1 > $temp2
		ln -s /usr/bin/fromdos /usr/bin/dos2unix
		dos2unix $temp2
		
		# need to remove all subdomains from $temp2 that do not begin with 0-9 or a-z. the unicode chars, encoded chars, etc. break the resolver

		echo "Making sure only valid subdomains exist in the final output by running resolve (github.com/majek/goplayground/resolve) "
		cat $temp2 | $HOME/work/bin/resolve -server="$resolveserver" > $temp3
		
		while read line; do
			STR="$(echo $line | cut -d',' -f 2)"
			if [[ ! -z "${STR// }"  ]]
				then echo $line >> $temp4
			fi
		done <$temp3
		cat $temp4 | cut -d',' -f 1 | sort -u > $finaloutputbeforealtdns

		rm $temp1 $temp2 $temp3 $temp4

		echo "Running ALTDNS now on the final output of the bruteforced subdomains"
		echo "The ALTDNS command used is altdns.py -i <finaloutput> -o data_output -w words.txt -r -e -d <altdnsserver> -s <altdnsoutputfile> -t 100"
		/usr/bin/python /opt/subscan/altdns/altdns.py -i $finaloutputbeforealtdns -o data_output -w words.txt -r -e -d $altdnsserver -s $altdnsoutput -t 100
		rm data_output

		echo "Getting the resolved subdomains from the ALTDNS output and combining them with the previously obtained bruteforced subdomains"

		TMP=$(echo $TARGETS | cut -d'.' -f 1)

		cat $altdnsoutput | cut -d':' -f 1 > $altdnsonlysubs
		sort -u $finaloutputbeforealtdns $altdnsonlysubs | grep $TMP > $finaloutputafteraltdns

		# if running nmap, resolve all subdomains to their IP, sort IP, and run nmap against those unique IPs.
		# keep track of what subdoamins are resolving to what IPs and what ports are open for a particular IP for posterity


		echo "END"
fi

