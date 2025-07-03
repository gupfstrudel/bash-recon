#!/bin/bash
 if [-z "&1"]; then
 echo "Usage: $0 <domain>"
 exit 1
 fi

 TARGET = $1
 OUT = "recon_$TARGET.txt"

 echo "[*] starting recon for $TARGET"
 echo "[*] Output will be saved in $OUT"
 echo "======= Recon Report for $TARGET =======" > $OUT
 
 echo "[*] Whois:" | tee -a $OUT
 whois $TARGET | head -n 20 >> $OUT

 echo "[*] DNS info:" | tee -a $OUT
 dig $TARGET ANY +short >> $OUT

 echo "[*] subdomains:" | tee -a $OUT
 for sub in www mail ftp test dev; do
  host "$sub.$TARGET" | grep "has address" >> $OUT
 done

 echo "[*] nmap scan top 1000 ports" | tee -a $OUT
 nmap -T4 -F $TARGET >> $OUT

 echo "[*] directory scan" | tee -a $OUT
 gobuster dir -u http://$TARGET -w /usr/share/wordlists/dirb/common.txt -q -t 20 >> $OUT

 echo "[*] Recon Complete. Check $OUT"
