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
						if [ -f "$f" ]; then
							#file exists and is not a directory
							echo "$f already exists.  ok to overwrite? [Y/n] "
							read overwrite
							if [ $overwrite != 'Y' ] && [ $overwrite != 'y' ]; then
								echo "file not overwritten.  exiting" 1>&2
								exit 1
							fi
						fi
					fi
					outfile="$f"
					nextone=0
					;;
				* )
					if [ -r "$f" ] && [ -f "$f" ]; then
						echo "$f"
						code="${code} --data-urlencode js_code@${f}"
					else
						echo "$f not found or not readable.  skipping" 1>&2
					fi
					;;
			esac
			;;
	esac
done

if [ "$code" = "" ]; then
	echo "no valid files specified.  exiting." 1>&2
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
	f.close()

	print "\nBuild file %s created.\n" % filename
' $@

