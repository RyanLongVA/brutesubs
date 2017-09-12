domain=$1
save_folder=$2
echo "$1" > ~/arsenal/recon/brutesubs/myoutdir/$save_folder/altInput.txt
echo "starting altdns"
python ./../altdns-master/altdns.py -i ./myoutdir/$save_folder/altInput.txt -w ./../altdns-master/all.txt -o ./myoutdir/$save_folder/alt.out
rm ./myoutdir/$save_folder/altInput.txt
echo "starting masscan"
../massdns/bin/massdns -r ../massdns/resolvers.txt -p -a -o -w ./myoutdir/$save_folder/mass.out1 ./myoutdir/$save_folder/alt.out
rm ./myoutdir/$save_folder/alt.out
