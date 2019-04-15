#!/usr/bin/env bash

function usage()
{
        echo "usage: bash Image_processing.sh [Options]"

        echo "Options"
	echo "  -d, 				assign the directory including the images youwant to process,the script will create an output directory under"
        echo "  -f, --file <file>              	filename"
        echo "  -cq, --compqua <percent>     	     	Image compression"
        echo "  -cr, --compreso            		Compresse image resolution"
	echo "  -crt <w|h>				compress image rosolution by width or heigh"
        echo "  -cf, --changeformat            	Change image format to jpg(Keep Original Image)"
        echo "  -w, --watermark <text>         	Add text watermark:"
        echo "  -sr, --suffix <suffix>        	Add suffixname"
        echo "  -pr, --prefix  <prefix>         	Add prefixname"
        echo "  -h,  --help"
}
function compressquality()
{
	origin_im=$1
	path=${origin_im%/*}
        origin_im=${origin_im##*/}
        extension=${origin_im##*.}
	extension=${extension^^}
	new_im=${path}'/'"compress.jpeg"
	echo $extension
	if [[ $extension == "JPEG" || $extension == "JPG" ]];then
		$(convert $1 -quality $2 $new_im)
		echo "Compress quality success"
	else
		echo "We can only compress JPEG/JPG images"
	fi
}
function compressresolution()
{
	origin_im=$1
	path=${origin_im%/*}
        origin_im=${origin_im##*/}
        extension=${origin_im##*.}
        extension=${extension^^}
	new_im=${path}'/'"cr"$origin_im
	if [[ $extension == "JPEG" || $extension == "PNG" || $extension == "SVG" ]];then
		if [[ $2 == "h" ]];then
			$(convert -resize "x"$3 $1 $new_im)
		elif [[ $2 == "w" ]];then
			$(convert -resize $3 $1 $new_im)
		echo "Compress solution success"
	        fi
	fi
}
function add_prefixname()
{
        origin_im=$1
        path=${origin_im%/*}'/'
        name=${origin_im##*/}
        new_im=$path$2$name
        $(mv $1 $new_im)
        echo "Prefix rename success"
}
function add_suffixname()
{
	origin_im=$1
    	oldname=${origin_im/%.*}
    	extension='.'${origin_im##*.}  
    	new_im=$oldname$2$extension 
    	$(mv $1 $new_im)
    	echo "Suffix rename success"

}
function add_watermark()
{
	origin_im=$1
	path=${origin_im%/*}
        origin_im=${origin_im##*/}
	extension=${origin_im##*.}
	name=${origin_im%.*}
	new_im=${path}'/'"add_w"${name}'.'${extension}
	$(convert $1 -gravity southeast -fill white -pointsize 32 -draw 'text 5,5 '\'$2\' $new_im)
	echo "Add watermark success"

}
function change_format()
{
	origin_im=$1
	extension=${origin_im##*.}
	name=${origin_im%.*}
	extension=${extension^^}
	if [[ $extension == "PNG" || $extension == "SVG" ]];then
		new_im=${name}".jpg"
		$(convert $origin_im $new_im)
	fi
	echo "Change format success"
}

while [ "$1" != "" ];do
	case $1 in
		-f)      shift
			 filename=$1
			 ;;
		-cq)     shift
		         quality=$1
		         ;;
		-cr)     shift
		         ratio=$1
			 ;;
	        -crt)    shift
			 crtype=$1
		         ;;
		-w)      shift
		         textcontent=$1
		         ;;
		-pr)     shift
		         prefix=$1
			 ;;
		-sr)	 shift
			 suffix=$1
                         ;;
	    
	        -cf)     shift
		         changeformat=1
			 ;;
		-h|--help)
			usage
			;;
	 esac
         shift
done
if [[ $quality && $filename ]];then
	compressquality $filename $quality
fi
if [[ $ratio && $filename ]];then
	compressresolution $filename $crtype $ratio
fi
if [[ $textcontent && $filename ]];then
	add_watermark $filename $textcontent
fi
if [[ $suffix && $filename ]];then
	add_suffixname $filename $suffix
fi
if [[ $prefix && $filename ]];then
        add_prefixname $filename $prefix
fi	
if [[ $changeformat ]];then
	change_format $filename
fi
