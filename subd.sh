domain=$1;
echo "Our target is $domain";
mkdir -p $domain/subdomain;
sublist3r.py -d $domain -o $domain/subdomain/sublist3r.txt;
subfinder -d $domain -o $domain/subdomain/subfinder.txt;
amass enum -d $domain -o $domain/subdomain/amass.txt;
anubis -t $domain |  grep "$domain" | grep -v "Searching for"| tee $domain/subdomain/anubis.txt;

curl -s "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u | tee $domain/subdomain/WaybackSub.txt ;
curl -s https://dns.bufferover.run/dns?q=.$domain |jq -r .FDNS_A[]|cut -d',' -f2|sort -u | tee $domain/subdomain/BufferSub.txt ;
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee $domain/subdomain/RiddlerSubs.txt ;
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee $domain/subdomain/crtSub.txt ;
curl -s "https://rapiddns.io/subdomain/$domain?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u | tee $domain/subdomain/RapidSub.txt ;

echo "Bruteforcing Sudomain..............";
knockpy.py $domain -o $domain/subdomain/$domain_knockpy ;


cat $domain/subdomain/*.txt |sort -u | grep $domain | tee $domain/subdomain/RawSub.txt;

echo "Subdomain Probing started............";

httpx -l $domain/subdomain/RawSub.txt -o $domain/subdomain/ProbedSub.txt;

echo "Historic data gathering started....................";

gau -subs --o $domain/historic_data.txt $domain;
echo "Starting Aquatone";
mkdir -p $domain/Aquatone ;
cat $domain/subdomain/ProbedSub.txt | aquatone ;
echo "COmpleted!!!!!!!!!!!!!"

