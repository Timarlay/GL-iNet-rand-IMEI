#!/bin/sh

table_value() {
    number=$1
    if [ $number -ge 9 ]; then echo 9;
    elif [ $number -ge 8 ];then echo 7;
    elif [ $number -ge 7 ]; then echo 5;
    elif [ $number -ge 6 ]; then echo 3;
    elif [ $number -ge 5 ]; then echo 1;
    elif [ $number -ge 4 ]; then echo 8;
    elif [ $number -ge 3 ]; then echo 6;
    elif [ $number -ge 2 ]; then echo 4;
    elif [ $number -ge 1 ]; then echo 2;
    elif [ $number -ge 0 ]; then echo 0; fi
}

luhn_checksum() {
        sequence="$1"
        sequence="${sequence//[^0-9]}"
        checksum=0

        i=${#sequence}
        if [ $(($i % 2)) -ne 0 ]; then
                sequence="0$sequence"
                i=$((i+1))
        fi

        while [ $i -ne 0 ];
        do
                checksum="$(($checksum + ${sequence:$((i - 1)):1}))"
                table_value=$(table_value ${sequence:$((i - 2)):1})
                checksum="$(($checksum + table_value))"
                i=$((i - 2))

        done
        checksum="$(($checksum % 10))"
        echo "$checksum"
}

imei_checkdigit() {
        sequence=$1
        check_digit=$(luhn_checksum "${sequence}0")
        if [ $check_digit -ne 0 ]; then
                check_digit=$((10 - $check_digit))
        fi
        echo "${sequence}${check_digit}"
}

IMEI="$(tr -dc 1-9 </dev/urandom | head -c 14)"
IMEI=$(imei_checkdigit $IMEI)
echo -e "AT+EGMR=1,7,\"${IMEI}\"" > /dev/ttyUSB3
echo "IMEI changed to ${IMEI}"