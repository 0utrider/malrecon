#!/bin/bash

# Banner
echo ""
echo -e "\033[1;35m   (_     __)       \033[1;96m  _____\033[0m"
echo -e "\033[1;35m     /|  /|       /)\033[1;96m (  /   )\033[0m"
echo -e "\033[1;35m    / | / |  _   // \033[1;96m   /__ /  _  _  _____\033[0m"
echo -e "\033[1;35m ) /  |/  |_(_(_(/_ \033[1;96m) /   \__(/_(__(_) / (_\033[0m"
echo -e "\033[1;35m(_/   '            \033[1;96m(_/\033[0m"
echo -e "          v1.02               \033[0;97mby Outrider\033[0m"
echo ""
echo -e "\033[2;0mBasic Malware Reconnaissance Tool\033[0m"
echo ""
echo ""

# Define the URL to be reconned
## Was the URL provided as an argument?
if [ -z "$1" ]
  then
    read -p 'URL: ' reconURL ## Ask the user for input if not
  else
	reconURL=$1 ## Set the URL if it was provided
	echo "URL: $reconURL"
fi

## Define the case number
read -p 'Case No.: ' reconCase
echo ""

# Create directory structure and change working directory
echo -e "Creating directory \033[0;97m$reconCase\033[0m ..."
mkdir -p ~/recon/$reconCase
cd ~/recon/$reconCase

# Basic recon functions begin here
## let's curl the URL provided by the user
## The user agent string (-A) is us pretending to be Internet Explorer 9 running on Windows 7
## For more user agents:		http://www.useragentstring.com/pages/useragentstring.php
echo -e "Performing\033[1;37m curl \033[0m..."
curl -s -o $reconCase.curl -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0" $reconURL 2>&1 | tee $reconCase.curl-log

## let's wget the URL provided by the user
echo -e "Performing\033[1;37m wget \033[0m..."
wget -q --user-agent="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0" -c $reconURL -O $reconCase.malware > $reconCase.wget

## let's run checksums on the wget download
echo -e "Generating\033[1;37m hashes \033[0m..."
md5sum $reconCase.malware > $reconCase.md5
sha256sum $reconCase.malware > $reconCase.sha256

## let's run file data
echo "Recording basic file details ..."

### file for file type basic info.
echo "=======================================================================" > $reconCase.properties

###  note that we start appending to the .properties file now with >> instead of >
echo "" >> $reconCase.properties
echo "File Information:" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
file $reconCase.malware >> $reconCase.properties
echo "" >> $reconCase.properties

### sprinkle in the hashes
echo "MD5 & SHA256 Hashes:" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
cat $reconCase.md5 >> $reconCase.properties
cat $reconCase.sha256 >> $reconCase.properties
echo "" >> $reconCase.properties

### od for for file header
echo "File Header:" >> $reconCase.properties
echo "" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
od -bc $reconCase.malware | head >> $reconCase.properties
echo "" >> $reconCase.properties
echo "" >> $reconCase.properties
echo "=======================================================================" >> $reconCase.properties

# Set permissions
echo "Setting permissions ..."
chmod 660 $reconCase.*

# wrap-up!
echo -e "\033[0;97mDone.\033[0m"
echo ""
echo -e "To see output files, navigate:    \e[38;5;214mcd ~/recon/$reconCase\033[0m\n"
