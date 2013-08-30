#!/bin/bash

SERVICE_URL=http://closure-compiler.appspot.com/compile
nextone=0
outfile="auto"
allowforce=0
code=""

for f in "$@"
do
	case $f in
		'-y' )
			allowforce=1
			;;
		'-o' )
			nextone='-o'
			;;
		* )
			case $nextone in
				'-o' )
					if [ $allowforce = 0 ]; then
						if [ -e "$f" ]; then
							echo "$f already exists.  ok to overwrite? [Y/n] "
							read overwrite
							if [ $overwrite != 'Y' ]; then
								echo "file not overwritten.  exiting"
								exit 1
							fi
						fi
					fi
					outfile="$f"
					nextone=0
					;;
				* )
					if [ -r "$f" ]; then
						code="${code} --data-urlencode js_code@${f}"
					else
						echo "$f not found or not readable.  skipping"
					fi
					;;
			esac
			;;
	esac
done

if [ "$code" = "" ]; then
	echo "no valid files specified.  exiting."
	exit 1
fi

if [ "$outfile" = "auto" ]; then
	outfile="c`date +"%d%m%y"`.js"
	echo "No output file specified.  compressed files will be saved as $outfile"
fi


# Send request
curl \
--url ${SERVICE_URL} \
--header 'Content-type: application/x-www-form-urlencoded' \
${code} \
--data output_format=json \
--data output_info=compiled_code \
--data output_info=statistics \
--data output_info=errors \
--data compilation_level=SIMPLE_OPTIMIZATIONS |

python -c '
import json, sys
data = json.load(sys.stdin)

if "errors" in data:
	print "### COMPILATION FAILED WITH ERRORS"
	for err in data["errors"]:
		file = sys.argv[int(err["file"].replace("Input_", "")) + 1]
		print "File: %s, %d:%d" % (file, err["lineno"], err["charno"])
		print "Error: %s" % err["error"]
		print "Line: %s" % err["line"]
		
	print "\nBuild failed.\n"
	
else:
	print "### COMPILATION COMPLETED"
	print "Original size: %db, gziped: %db" % (data["statistics"]["originalSize"], data["statistics"]["originalGzipSize"])
	print "Compressed size: %db, gziped: %db" % (data["statistics"]["compressedSize"], data["statistics"]["compressedGzipSize"])
	print "Compression rate: %.2f" % (float(data["statistics"]["compressedSize"]) / int(data["statistics"]["originalSize"]))

	filename = "'${outfile}'"
	f = open(filename, "w")
	f.write(data["compiledCode"])

	print "\nBuild file %s created.\n" % filename
' $@


echo "$outfile"
echo "${code}"
