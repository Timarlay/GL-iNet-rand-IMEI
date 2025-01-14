mv ./random_imei.sh /lib/functions/random_imei.sh

echo "./lib/functions/random_imei.sh" | cat - /etc/rc.local > /tmp/rc.local.tmp
mv /tmp/rc.local.tmp /etc/rc.local
