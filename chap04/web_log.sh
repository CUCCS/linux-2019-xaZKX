#!/usr/bin/env bash

function get_top_host()
{
	echo "访问来源主机TOP 100和分别对应出现的总次数:"
	more +2 web_log.tsv | awk -F '\t' '{print $1}' | sort | uniq -c | sort -nr | head -n 100
}
function get_top_ip()
{
	echo "访问来源主机TOP 100 IP和分别对应出现的总次数:"
	more +2 web_log.tsv | awk -F '\t' '{print $1}' | grep -E '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
}
function get_frequent_url()
{
	echo "最频繁被访问的URL TOP 100:"
	more +2 web_log.tsv | awk -F '\t' '{print $5}' | sort | uniq -c | sort -nr | head -n 100
}
function get_response()
{
	number=$(more +2 web_log.tsv | awk -F '\t' '{print $6}'| sort | uniq -c | sort -nr | awk '{print $1}' )
	response=$(more +2 web_log.tsv | awk -F '\t' '{print $6}'| sort | uniq -c | sort -nr | awk '{print $2}' )
	sum=0
	for i in $number
	do
		sum=$(($sum+$i))

	done
	count=0
	declare -a resp_arr
	for i in $number
        do
		resp_arr[$count]=$(echo "scale=8; 100*${i} / $sum" | bc)

		let count+=1
	done	
	count=0
	echo "不同响应状态码的出现次数和对应百分比:\n"
	for j in $response
	do
		
		if [ $(echo "${resp_arr[$count]} > 1" | bc) -eq 0 ];then
			echo "[Response Code]: $j; [Proportion]: 0${resp_arr[$count]}%"
		else
			echo "[Response Code]: $j; [Proportion]: ${resp_arr[$count]}%"
		fi
		let count+=1
	done
}
function get_4xxcode()
{
	echo "不同4XX状态码对应的TOP 10 URL和对应出现的总次数:"
	echo "[Response code: 404]:"
	more +2 web_log.tsv | awk -F '\t' '{print $6,$5}' | grep '404 ' | sort | uniq -c | sort -nr | head -n 10

	echo "[Response code: 403]:"
	more +2 web_log.tsv | awk -F '\t' '{print $6,$5}' | grep '403 ' | sort | uniq -c | sort -nr | head -n 10
}
function get_certainhost()
{	

	echo "给定URL输出TOP 100访问来源主机"
	
  	more +2 web_log.tsv | grep $url | awk -F '\t' '{print $1}' | sort | uniq -c | sort -nr | head -n 100
}
function usage()
{
	echo "Usage: bash web_log.sh [OPTION]"
	echo "OPTIONS:"
	echo "-a			show TOP 100 host"
	echo "-b 			show TOP 100 IP"
	echo "-c 			show TOP 100 frequency url"
	echo "-d 			show responsecode and count and porprotion"
	echo "-e 			show TOP 10 4XX responsecode  url"
	echo "-f [url]	        show TOP 100 given url of host"
	echo "-h,--help               show help information" 
}
while [ "$1" != "" ]; do
    case $1 in
	    	-a)                 get_top_host
                    	            exit
                        	        ;;
		-b)                 get_top_ip
                                    exit
                                	;;
		-c)                 get_frequent_url
                                    exit
                               		;;
		-d)                 get_response
                                    exit
                                	;;
		-e)                 get_4xxcode
                                    exit
                                	;;
		-f) url=$2;       get_certainhost 
                                    exit
                                	;;
         	-h|--help)             usage
                                    exit
                                	;;
    esac
done
