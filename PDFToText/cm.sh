#!/bin/sh
# Demonstrates the extraction of text in tabular format from a PDF file.
# This depends upon pdftotext (v0.14.5) from  poppler-utils ( http://poppler.freedesktop.org).
# This has been tested on a Linux box. But you should be able to run it
# on a MINGW32 shell/bash Windows environment as well (but you will need
# to make adjustments for CRLF on Windows environment when making outputs). 
# Alternatively, simply echo to terminal.

# Make sure you have the executable permission on this shell script.
# chmod +x cm.sh

rm -rf *.txt

#today=`date +%d-%m-%y`
today="MyPDF"

# Get the first page with the watch-list of top 100 stocks
pdftotext -f 1 -l 1 -layout -q ${today}_Part_3.pdf ${today}_Part_3.txt

# Now let's begin extracting the column/row values that we are interested in.
while IFS='' read -r line || [[ -n "$line" ]]; do
	strippedLine=`echo "$line" | sed 's/\\r//g' | sed 's///g'`
	# We are only interested in those lines that do not have long textual statements. 
	# Instead, let's only focus on extracting values from table column/rows and ignore 
	# other such lines.
	if echo "$line" | grep -q "StockWatch" || echo "$line" | grep -q "Watch list" || echo "$line" | grep -q "fundamentally" || echo "$line" | grep -q "fundamentally" || echo "$line" | grep -q "removing" || echo "$line" | grep -q "CAPITAL MARKET"; then
		continue
	elif [ -n "$strippedLine" ]; then
		# Get the Company Name from Column 1
		companyName1=`echo "$line" | tail -c +1 | head -c 18`
		companyNameNoSpace="$(echo -e "${companyName1}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		if [[ ! -z $companyNameNoSpace ]]; then
			# We don't want to process column headers
			if [ "$companyNameNoSpace" != "COMPANY" ]; then
				# We don't want to process notes etc. that are marked with *.
				if [ "$companyNameNoSpace" != "* indicates that E" ]; then
					lineLength=`echo "${#line}"`
					companyName1=`echo "$line" | tail -c +1 | head -c 19`
                	industryIndex1=`echo "$line" | tail -c +27 | head -c 3`
					marketPrice1=`echo "$line" | tail -c +38 | head -c 6`
					ttmYear1=`echo "$line" | tail -c +53 | head -c 6`
					ttmEPS1=`echo "$line" | tail -c +69 | head -c 6`
					PE1=`echo "$line" | tail -c +83 | head -c 4`
					companyName2=`echo "$line" | tail -c +99 | head -c 20`
					
					# .. etc.
					echo "companyName1:"${companyName1}
					echo "industryIndex1:"${industryIndex1}
					echo "marketPrice1:"${marketPrice1}
					echo "ttmYear1:"${ttmYear1}
					echo "ttmEPS1:"${ttmEPS1}
					echo "PE1:"${PE1}
					echo "companyName2:"${companyName2}
					echo ""
					echo "################################"
					echo ""
                 fi
			fi
		fi
	fi
done < "${today}_Part_3.txt"
