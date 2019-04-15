#!/usr/bin/env bash
function usage()
{
	echo "usage: bash worldcup.sh [Options]"
        echo "Options"
	echo "-a        统计不同年龄区间范围的球员数量、百分比"
	echo "-b        统计不同场上位置的球员数量、百分比"
	echo "-c        找出名字最长的球员以及名字最短的球员"
	echo "-d        找出年龄最大的球员以及年龄最小的球员"
	echo "-h|-help        获取帮助信息"
}


function get_age()
{
	player_num=0
	# 所有年龄的集合
	age_arr=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
	
	# 20岁以下人数
	age_down=0
	# 20-30岁之间人数
	age_bt=0
	# 30岁以上人数
	age_over=0

	# 统计各年龄段人数
	for i in $age_arr
	do
		if [ $i != 'Age' ];then
			let player_sum+=1
			if [ $i -lt 20 ];then
				let age_down+=1
			elif [ $i -ge 20 ] && [ $i -le 30 ];then
				 let age_bt+=1
			else
				let age_over+=1
			fi
		fi
	done
	avg1=$(echo "scale=2; $age_down*100/$player_sum" | bc -l)
	avg2=$(echo "scale=2; $age_bt*100/$player_sum" | bc -l)
	avg3=$(echo "scale=2; $age_over*100/$player_sum" | bc -l)
	echo "[20岁以下]: [人数]: ${age_down}; [比例]: ${avg1}%"
	echo "[20-30岁]: [人数]: ${age_bt}; [比例]: ${avg2}%"
	echo "[30岁以上]: [人数]: ${age_over}; [比例]: ${avg3}%"     
	
}
function get_position()
{
	# 所有位置的集合
        position_arr=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
        Goalie_num=0
        Defender_num=0
        Midfielder_num=0
	Forward_num=0
	player_num=0
	for i in $position_arr
	do
		if [ $i != 'Position' ];then
                        let player_sum+=1
		fi
		if [ $i == 'Goalie' ];then
			let Goalie_num+=1
		
		elif [ $i == 'Defender' ];then
			let Defender_num+=1
		
		elif [ $i == 'Midfielder' ];then
                	let Midfielder_num+=1
		
		elif [ $i == 'Forward' ];then
                        let Forward_num+=1
		fi

	done
	avg1=$(echo "scale=2; $Goalie_num*100/$player_sum" | bc -l)
	echo $player_num
	avg2=$(echo "scale=2; $Defender_num*100/$player_sum" | bc -l)
	avg3=$(echo "scale=2; $Midfielder_num*100/$player_sum" | bc -l)
	avg4=$(echo "scale=2; $Forward_num*100/$player_sum" | bc -l)
	echo "[Goalie]: [人数]: ${Goalie_num}; [比例]: ${avg1}%"
	echo "[Defender]: [人数]: ${Defender_num}; [比例]: ${avg2}%"
	echo "[Midfielder]: [人数]: ${Midfielder_num}; [比例]: ${avg3}%"
	echo "[Forward]: [人数]: ${Forward_num}; [比例]: ${avg4}%"  

}
function get_longest()
{
	longest_name_length=0
	shortest_name_length=100
	longest_name=''
	shortest_name=''
	count=0
	name_arr=$( awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
	for i in $name_arr
	do
		let count+=1
		if [ $i -gt $longest_name_length ];then
			longest_name_length=$i
		fi
		if [ $i -lt $shortest_name_length ];then
			shortest_name_length=$i
		fi
	done
	longest_name=$(awk -F '\t' 'length($9)=='$longest_name_length' {print $9}' worldcupplayerinfo.tsv)
	shortest_name=$(awk -F '\t' 'length($9)=='$shortest_name_length' {print $9}' worldcupplayerinfo.tsv)
	echo "[名字最长的球员]: '$longest_name'"
	echo "[名字最短的球员]: '$shortest_name'"

}

function get_oldest()
{
	count=0
	age_arr=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
	name_arr=$(awk -F '\t' '{print $9}' worldcupplayerinfo.tsv)	
	the_oldest_age=0
	the_youngest_age=100
	the_oldest_name=''
	the_youngest_name=''
	for i in $age_arr
	do
		let count+=1
		if [ $i != 'Age' ];then
			if [ $i -gt $the_oldest_age ];then
				the_oldest_age=$i
				the_oldest_name=$(awk -F '\t' 'NR=='$count' {print $9}' worldcupplayerinfo.tsv)
			fi
			if [ $i -lt $the_youngest_age ];then
				the_youngest_age=$i
				the_youngest_name=$(awk -F '\t' 'NR=='$count' {print $9}' worldcupplayerinfo.tsv)
			fi
		fi
	done
	echo "[年龄最大的球员是]: '$the_oldest_name';[他的年龄是]: '$the_oldest_age'岁."
	echo "[年龄最小的球员是]: '$the_youngest_name';[他的年龄是]: '$the_youngest_age'岁."
	
}
while [ "$1" != "" ] ; do
	case $1 in
		-a)
			get_age
			;;
		-b)
			get_position
			;;
		-c)
			get_longest
			;;
		-d)
			get_oldest
			;;
		-h|--help)
			usage
			;;
	esac
	shift
done
